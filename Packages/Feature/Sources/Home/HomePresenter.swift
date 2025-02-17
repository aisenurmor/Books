//
//  HomePresenter.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Combine
import Foundation
import Model
import UICore

public final class HomePresenter: HomePresenterProtocol {
    
    @Published public var viewState: ViewState<HomeState> = .loading
    @Published public var selectedSortOption: SortOption = .all
    
    private var cancellables = Set<AnyCancellable>()
    
    private let interactor: HomeInteractorProtocol
    private let router: HomeRouterProtocol
    
    public init(
        interactor: HomeInteractorProtocol,
        router: HomeRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
        
        observeFavorites()
    }
}

// MARK: - HomePresenterProtocol
public extension HomePresenter {
    
    func viewDidLoad() {
        guard case .loading = viewState else { return }
        fetchBooks()
    }
    
    func loadMoreIfNeeded(for book: Book) {
        guard case .loaded(let state) = viewState,
              state.books.last?.id == book.id,
              !state.isPaginationLoading,
              !state.isEndOfList,
              selectedSortOption == .all
        else { return }
        
        var updatedState = state
        updatedState.isPaginationLoading = true
        viewState = .loaded(updatedState)
        fetchBooks()
    }
    
    func toggleFavorite(for id: String) {
        Task {
            await interactor.toggleFavorite(for: id)
        }
    }
    
    func sort(by option: SortOption) {
        guard selectedSortOption != option else { return }
        selectedSortOption = option
        fetchSortedBooks()
    }
    
    func retry() {
        viewState = .loading
        fetchBooks()
    }
    
    func navigateToSearch() {
        router.navigateToSearch()
    }
    
    func navigateToDetail(by id: String) {
        router.navigateToDetail(by: id)
    }
}

// MARK: - Private Methods
private extension HomePresenter {
    
    func observeFavorites() {
        Task {
            await interactor.observeFavoritesChanges()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] books in
                    self?.fetchSortedBooks()
                }
                .store(in: &cancellables)
        }
    }
    
    func fetchBooks() {
        Task {
            do {
                let books = try await interactor.fetchBooks(with: selectedSortOption)
                updateState(with: books)
            } catch {
                updateState(errorMessage: error.localizedDescription)
            }
        }
    }
    
    func fetchSortedBooks() {
        Task {
            do {
                let sortedBooks = try await interactor.sortBooks(by: selectedSortOption)
                updateState(with: sortedBooks)
            } catch {
                updateState(errorMessage: error.localizedDescription)
            }
        }
    }
    
    func updateState(with books: [Book] = [], errorMessage: String? = nil) {
        DispatchQueue.main.async {
            if let errorMessage {
                self.viewState = .error(message: errorMessage)
            } else {
                let state = HomeState(
                    books: books,
                    isPaginationLoading: false,
                    isEndOfList: books.count >= 100
                )
                self.viewState = .loaded(state)
            }
        }
    }
}
