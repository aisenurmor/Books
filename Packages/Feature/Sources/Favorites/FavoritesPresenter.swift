//
//  FavoritesPresenter.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Combine
import Foundation
import Model
import UICore

final class FavoritesPresenter: FavoritesPresenterProtocol {
    
    @Published private(set) var viewState: ViewState<[Book]> = .loading
    
    private var cancellables = Set<AnyCancellable>()
    
    private let interactor: FavoritesInteractorProtocol
    private let router: FavoritesRouterProtocol
    
    init(
        interactor: FavoritesInteractorProtocol,
        router: FavoritesRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
        
        observeFavorites()
    }
}

extension FavoritesPresenter {
    
    func viewDidLoad() {
        fetchFavorites()
    }
    
    func toggleFavorite(for id: String) {
        Task {
            await interactor.toggleFavorite(for: id)
        }
    }
    
    func navigateToDetail(by id: String) {
        router.navigateToDetail(by: id)
    }
}

// MARK: - Private Methods
private extension FavoritesPresenter {
    
    func fetchFavorites() {
        Task {
            let books = try await interactor.fetchFavorites()
            
            await MainActor.run {
                viewState = .loaded(books)
            }
        }
    }
    
    func observeFavorites() {
        Task {
            await interactor.observeFavoritesChanges()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] books in
                    self?.fetchFavorites()
                }
                .store(in: &cancellables)
        }
    }
}
