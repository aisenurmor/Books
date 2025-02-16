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
    
    @Published private(set) var books: [Book] = []
    @Published private(set) var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let pageSize = 20
    private var currentPage = 1 {
        willSet {
            if newValue >= 1 {
                self.currentPage = newValue
            }
        }
    }
    
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
        guard let lastItemId = books.last?.id, lastItemId == id else {
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
        books = interactor.sortBooks(by: option)
    }
}

private extension HomePresenter {
    
    func loadMoreBooks() {
        guard !isLoading else { return }
        currentPage += 1
        refreshBooks(currentPage*pageSize)
    }
    
    func refreshBooks(_ itemCount: Int = 20) {
        isLoading = true
        
        Task {
            do {
                let response = try await interactor.fetchBooks(itemCount)
                
                await MainActor.run {
                    self.books = response
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.currentPage -= 1
                }
            }
        }
    }
}
