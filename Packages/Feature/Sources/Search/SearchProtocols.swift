//
//  SearchProtocols.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Foundation
import Model

// MARK: View Protocol
public protocol SearchViewProtocol {
    var presenter: any SearchPresenterProtocol { get }
}

// MARK: - Presenter Protocol
public protocol SearchPresenterProtocol: ObservableObject {
    var categories: [BookCategory] { get }
    
    func retry()
    func navigateToDetail(by id: String)
}

// MARK: - Interactor Protocol
public protocol SearchInteractorProtocol {
    func getCategories() async throws -> [BookCategory]
    func searchBooks(query: String, category: BookCategory?) async throws -> [Book]
}

// MARK: - Router Protocol
public protocol SearchRouterProtocol {
    func navigateToDetail(by id: String)
}

// MARK: - Entity Protocol
public protocol SearchEntityProtocol { }
