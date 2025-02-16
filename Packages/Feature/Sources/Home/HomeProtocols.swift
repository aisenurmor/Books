//
//  HomeProtocols.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Combine
import Model
import SwiftUI

// MARK: - View Protocol
protocol HomeViewProtocol: AnyObject {
    var presenter: any HomePresenterProtocol { get }
}

// MARK: - Presenter Protocol
protocol HomePresenterProtocol: ObservableObject {
    
    var books: [Book] { get }
    
    func viewDidLoad()
    func toggleFavorite(for id: String)
}

// MARK: - Interactor Protocol
protocol HomeInteractorProtocol {
    func fetchBooks(_ itemCount: Int) async throws -> [Book]
    func toggleFavorite(for id: String) async throws
    func sortBooks(by option: SortOption) async throws -> [Book]
    func observeFavorites() async -> AnyPublisher<[Book], Never>
    func getFavoriteIds() async throws -> Set<String>
}

// MARK: - Router Protocol
protocol HomeRouterProtocol {
    func navigateToDetail(for book: Book)
    func navigateToSearch()
}

// MARK: - Entity Protocol
protocol HomeEntityProtocol { }
