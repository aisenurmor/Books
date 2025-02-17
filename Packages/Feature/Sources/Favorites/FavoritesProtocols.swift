//
//  FavoritesProtocols.swift
//  
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Combine
import Foundation
import Model

// MARK: - View Protocol
protocol FavoritesViewProtocol: AnyObject {
    var presenter: any FavoritesPresenterProtocol { get }
}

// MARK: - Presenter Protocol
protocol FavoritesPresenterProtocol: ObservableObject {
    func viewDidLoad()
    func toggleFavorite(for id: String)
    func navigateToDetail(by id: String)
}

// MARK: - Interactor Protocol
protocol FavoritesInteractorProtocol {
    func fetchFavorites() async throws -> [Book]
    func toggleFavorite(for id: String) async
    func observeFavoritesChanges() async -> AnyPublisher<Bool, Never>
}

// MARK: - Router Protocol
protocol FavoritesRouterProtocol {
    func navigateToDetail(by id: String)
}

// MARK: - Entity Protocol
protocol FavoritesEntityProtocol { }

