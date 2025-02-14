//
//  HomeProtocols.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

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
    func toggleFavorite(for book: Book)
}

// MARK: - Interactor Protocol
protocol HomeInteractorProtocol {
    func fetchBooks() async throws -> [Book]
    func toggleFavorite(for book: Book) async throws
}

// MARK: - Router Protocol
protocol HomeRouterProtocol {
    func navigateToDetail(for book: Book)
    func navigateToSearch()
}

// MARK: - Entity Protocol
protocol HomeEntityProtocol { }
