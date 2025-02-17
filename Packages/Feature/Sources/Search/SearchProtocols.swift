//
//  SearchProtocols.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Foundation
import Model

// MARK: View Protocol
protocol SearchViewProtocol {
    var presenter: any SearchPresenterProtocol { get }
}

// MARK: - Presenter Protocol
protocol SearchPresenterProtocol: ObservableObject {
    var categories: [BookCategory] { get }
    
    func retry()
    func navigateToDetail(by id: String)
}

// MARK: - Interactor Protocol
protocol SearchInteractorProtocol {
    func getCategories() async throws -> [BookCategory]
    func searchBooks(query: String, category: BookCategory?) async throws -> [Book]
}

// MARK: - Router Protocol
protocol SearchRouterProtocol {
    func navigateToDetail(by id: String)
}

// MARK: - Entity Protocol
protocol SearchEntityProtocol { }
