//
//  MockSearchInteractor.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Model

@testable import Feature

final class MockSearchInteractor: SearchInteractorProtocol {
    // MARK: - Properties
    private(set) var getCategoriesCallCount = 0
    var getCategoriesResult: Result<[BookCategory], Error> = .success([])
    
    private(set) var searchBooksCallCount = 0
    private(set) var lastSearchQuery: String?
    private(set) var lastSearchCategory: BookCategory?
    var searchBooksResult: Result<[Book], Error> = .success([])
    
    // MARK: - Methods
    func getCategories() async throws -> [BookCategory] {
        getCategoriesCallCount += 1
        
        switch getCategoriesResult {
        case .success(let categories):
            return categories
        case .failure(let error):
            throw error
        }
    }
    
    func searchBooks(query: String, category: BookCategory?) async throws -> [Book] {
        searchBooksCallCount += 1
        lastSearchQuery = query
        lastSearchCategory = category
        
        switch searchBooksResult {
        case .success(let books):
            return books
        case .failure(let error):
            throw error
        }
    }
}
