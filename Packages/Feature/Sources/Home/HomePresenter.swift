//
//  HomePresenter.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Combine
import Foundation
import Model

@MainActor
final class HomePresenter: ObservableObject {
    
    @Published private(set) var books: [Book] = []
    @Published private(set) var selectedSortOption: SortOption = .all
    @Published private(set) var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let pageSize = 20
    private var currentPage = 1
    
    private let interactor: HomeInteractorProtocol
    private let router: HomeRouterProtocol
    
    init(
        interactor: HomeInteractorProtocol,
        router: HomeRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
        
        setupBindings()
    }
    
    func loadMoreIfNeeded(for book: Book) {
        guard let lastBook = books.last,
              lastBook.id == book.id,
              !isLoading,
              selectedSortOption == .all else {
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
        guard books.isEmpty else { return }
        refreshBooks()
    }
    
    func toggleFavorite(for id: String) {
        Task {
            try await interactor.toggleFavorite(for: id)
        }
    }
    
    func sort(by option: SortOption) {
        guard selectedSortOption != option else { return }
        selectedSortOption = option
        
        Task {
            let sortedBooks = try await interactor.sortBooks(by: option)
            self.books = sortedBooks
        }
    }
}

private extension HomePresenter {
    
    func setupBindings() {
        Task {
            await setupFavoritesObservation()
        }
    }
    
    func setupFavoritesObservation() async {
        await interactor.observeFavorites()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ids in
                self?.books = ids
                self?.updateBooksIfNeeded()
            }
            .store(in: &cancellables)
    }
    
    func loadMoreBooks() {
        let nextPage = currentPage + 1
        let itemCount = nextPage * pageSize
        
        Task {
            await fetchBooks(itemCount)
        }
    }
    
    func refreshBooks() {
        Task {
            await fetchBooks(pageSize)
        }
    }
    
    func fetchBooks(_ itemCount: Int) async {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            books = try await interactor.fetchBooks(itemCount)
            currentPage = itemCount / pageSize
        } catch {
            debugPrint(error.localizedDescription)
        }
        
        isLoading = false
    }
    
    func updateBooksIfNeeded() {
        guard selectedSortOption == .onlyLiked else { return }
        
        Task {
            let sortedBooks = try await interactor.sortBooks(by: .onlyLiked)
            self.books = sortedBooks
        }
    }
}
