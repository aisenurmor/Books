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
    
    var books: [Book] { get }
    
    func viewDidLoad()
    func loadMoreIfNeeded(for book: Book)
    func toggleFavorite(for id: String)
    func navigateToSearch()
}

// MARK: - Interactor Protocol
protocol HomeInteractorProtocol {
    func fetchMoreBooks() async throws -> [Book]
    func refreshBooks() async throws -> [Book]
    func toggleFavorite(for id: String) async throws
    func sortBooks(by option: SortOption) async throws -> [Book]
    func observeFavorites() async -> AnyPublisher<[Book], Never>
}

// MARK: - Router Protocol
protocol HomeRouterProtocol {
    func navigateToDetail(for book: Book)
    func navigateToSearch()
}

// MARK: - Entity Protocol
protocol HomeEntityProtocol { }
