//
//  HomePresenter.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Combine
import Foundation
import Model

final class HomePresenter: ObservableObject {
    
    @Published private(set) var paginatedBooks: [Book] = []
    @Published private(set) var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private var allBooks: [Book] = []
    private let pageSize = 20
    private var currentPage = 0
    
    private let interactor: HomeInteractorProtocol
    private let router: HomeRouterProtocol
    
    init(
        interactor: HomeInteractorProtocol,
        router: HomeRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    func loadMoreIfLastItem(_ id: String) {
        guard let lastItemId = paginatedBooks.last?.id, lastItemId == id else {
            return
        }
        loadMoreBooks()
    }
    
    func navigateToSearch() {
        router.navigateToSearch()
    }
}

extension HomePresenter: HomePresenterProtocol {
    
    func viewDidLoad() {
        refreshBooks()
    }
    
    func toggleFavorite(for book: Book) {
        // TODO: Add action
    }
    
    func sort(by option: SortOption) {
        reset()
        allBooks = interactor.sortBooks(books: allBooks, by: option)
        loadMoreBooks()
        isLoading = false
    }
}

private extension HomePresenter {
    
    func loadMoreBooks() {
        guard !isLoading else { return }
        
        let startIndex = currentPage * pageSize
        let endIndex = min(startIndex + pageSize, allBooks.count)
        let nextBatch = Array(allBooks[startIndex..<endIndex])
        
        paginatedBooks.append(contentsOf: nextBatch)
        currentPage += 1
    }
    
    func refreshBooks() {
        Task {
            do {
                let response = try await interactor.fetchBooks()
                
                await MainActor.run {
                    self.allBooks = response
                    self.loadMoreBooks()
                    self.isLoading = false
                }
            } catch {
                debugPrint("Error fetching books: \(error)")
            }
        }
    }
    
    func reset() {
        currentPage = 0
        paginatedBooks = []
    }
}
