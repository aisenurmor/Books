//
//  HomeProtocols.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Combine
import Foundation
import Model

// MARK: - View Protocol
protocol HomeViewProtocol: AnyObject {
    var presenter: any HomePresenterProtocol { get }
}

// MARK: - Presenter Protocol
protocol HomePresenterProtocol: ObservableObject {
    func viewDidLoad()
    func loadMoreIfNeeded(for book: Book)
    func toggleFavorite(for id: String)
    func navigateToSearch()
    func navigateToDetail(by id: String)
}

// MARK: - Interactor Protocol
protocol HomeInteractorProtocol {
    func fetchBooks(with sortOption: SortOption) async throws -> [Book]
    func toggleFavorite(for id: String) async
    func sortBooks(by option: SortOption) async throws -> [Book]
    func observeFavoritesChanges() async -> AnyPublisher<Bool, Never>
}

// MARK: - Router Protocol
protocol HomeRouterProtocol {
    func navigateToDetail(by id: String)
    func navigateToSearch()
}

// MARK: - Entity Protocol
protocol HomeEntityProtocol { }
