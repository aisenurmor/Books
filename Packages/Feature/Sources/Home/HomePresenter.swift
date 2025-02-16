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
extension HomePresenter: HomePresenterProtocol {
    
    func viewDidLoad() {
        guard books.isEmpty else { return }
        refreshBooks()
    }
    
    func loadMoreIfNeeded(for book: Book) {
        guard isLastItem(book),
              !isLoading,
              selectedSortOption == .all
        else {
            return
        }
        loadMoreBooks()
    }
    
    func toggleFavorite(for id: String) {
        Task {
            do {
                try await interactor.toggleFavorite(for: id)
                await updateBooksIfNeeded()
            } catch {
                debugPrint("An error occured when toggle favorite state: \(error.localizedDescription)")
            }
        }
    }
    
    func sort(by option: SortOption) {
        guard selectedSortOption != option else { return }
        selectedSortOption = option
        
        Task {
            do {
                books = try await interactor.sortBooks(by: option)
            } catch {
                debugPrint("An error occured when sorting books: \(error.localizedDescription)")
            }
        }
    }
    
    func navigateToSearch() {
        router.navigateToSearch()
    }
}

// MARK: - Private Methods
private extension HomePresenter {
    
    func setupBindings() async {
        Task {
            await interactor.observeFavorites()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] books in
                    guard let self else { return }
                    self.books = Array(books)
                    
                    Task {
                        await self.updateBooksIfNeeded()
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    func loadMoreBooks() {
        Task {
            isLoading = true
            do {
                books = try await interactor.fetchMoreBooks()
            } catch {
                debugPrint("An error occured when fetch more books: \(error.localizedDescription)")
            }
            isLoading = false
        }
    }
    
    func refreshBooks() {
        Task {
            isLoading = true
            do {
                books = try await interactor.refreshBooks()
            } catch {
                debugPrint("An error occured when refresh books: \(error.localizedDescription)")
            }
            isLoading = false
        }
    }
    
    func updateBooksIfNeeded() async {
        guard selectedSortOption == .onlyLiked else { return }
        do {
            books = try await interactor.sortBooks(by: .onlyLiked)
        } catch {
            debugPrint("An error occured when fetch books: \(error.localizedDescription)")
        }
    }
    
    func isLastItem(_ book: Book) -> Bool {
        books.last?.id == book.id
    }
}
