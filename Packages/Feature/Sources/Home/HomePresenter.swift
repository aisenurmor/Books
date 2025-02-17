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

final class HomePresenter: HomePresenterProtocol {
    
    @Published private(set) var viewState: ViewState<HomeState> = .loading
    @Published private(set) var selectedSortOption: SortOption = .all
    @Published private(set) var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let interactor: HomeInteractorProtocol
    private let router: HomeRouterProtocol
    
    init(
        interactor: HomeInteractorProtocol,
        router: HomeRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
        
        Task {
            await setupBindings()
        }
    }
}

// MARK: - HomePresenterProtocol
@MainActor
extension HomePresenter {
    
    func viewDidLoad() {
        guard case .loading = viewState else { return }
        refreshBooks()
    }
    
    func loadMoreIfNeeded(for book: Book) {
        guard case .loaded(let state) = viewState,
              isLastItem(book),
              !state.isPaginationLoading,
              !state.isEndOfList,
              selectedSortOption == .all
        else { return }
        
        loadMoreBooks()
    }
    
    func toggleFavorite(for id: String) {
        Task {
            do {
                try await interactor.toggleFavorite(for: id)
            } catch {
                updateState(errorMessage: error.localizedDescription)
            }
        }
    }
    
    func sort(by option: SortOption) {
        guard selectedSortOption != option else { return }
        selectedSortOption = option
        
        Task {
            do {
                let sortedBooks = try await interactor.sortBooks(by: option)
                updateState(with: sortedBooks)
            } catch {
                updateState(errorMessage: error.localizedDescription)
            }
        }
    }
    
    func retry() {
        loadMoreBooks()
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
    
    func setupBindings() async {
        await interactor.observeFavorites()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] books in
                guard let self else { return }
                Task {
                    await self.updateBooks(with: books)
                }
            }
            .store(in: &cancellables)
    }
    
    func loadMoreBooks() {
        guard case .loaded(var state) = viewState else { return }
        state.isPaginationLoading = true
        viewState = .loaded(state)
        
        Task {
            do {
                let books = try await interactor.fetchMoreBooks()
                updateState(with: books)
            } catch {
                updateState(errorMessage: error.localizedDescription)
            }
        }
    }
    
    func refreshBooks() {
        Task {
            do {
                let books = try await interactor.refreshBooks()
                updateState(with: books)
            } catch {
                updateState(errorMessage: error.localizedDescription)
            }
        }
    }
    
    func updateBooks(with books: [Book]) async {
        guard selectedSortOption != .all else {
            updateState(with: books)
            return
        }
        do {
            let books = try await interactor.sortBooks(by: selectedSortOption)
            updateState(with: books)
        } catch {
            updateState(errorMessage: error.localizedDescription)
        }
    }
    
    func updateState(with books: [Book] = [], errorMessage: String? = nil) {
        if let errorMessage {
            DispatchQueue.main.async {
                self.viewState = .error(message: errorMessage)
            }
            return
        }
        let state = HomeState(
            books: books,
            isPaginationLoading: false,
            isEndOfList: books.count >= 100
        )
        DispatchQueue.main.async {
            self.viewState = .loaded(state)
        }
    }
    
    func isLastItem(_ book: Book) -> Bool {
        guard case .loaded(let state) = viewState else { return false }
        return state.books.last?.id == book.id
    }
}

struct HomeState {
    var books: [Book]
    var isPaginationLoading: Bool
    var isEndOfList: Bool
    
    static var empty: HomeState {
        HomeState(books: [], isPaginationLoading: false, isEndOfList: false)
    }
}
