//
//  MockBooksRepository.swift
//  
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Combine
import Model
import Repository

@testable import Feature

final class MockBooksRepository: BooksRepositoryProtocol {
    
    // MARK: - Properties
    private(set) var createBooksCallCount = 0
    private(set) var lastCreatedBooks: [BookResponseModel]?
    var createBooksResult: Result<[Book], Error> = .success([])
    
    private(set) var toggleFavoriteCallCount = 0
    private(set) var lastToggleId: String?
    var toggleFavoriteError: Error?
    
    private(set) var sortBooksCallCount = 0
    private(set) var lastSortOption: SortOption?
    var sortBooksResult: Result<[Book], Error> = .success([])
    
    private(set) var getFavoritesCallCount = 0
    var getFavoritesResult: Result<Set<String>, Error> = .success([])
    
    private(set) var getCategoriesCallCount = 0
    var getCategoriesResult: Result<[BookCategory], Error> = .success([])
    
    private(set) var getBookDetailCallCount = 0
    private(set) var lastRequestedBookId: String?
    var getBookDetailResult: Result<Book?, Error> = .success(nil)
    
    private(set) var searchBooksCallCount = 0
    private(set) var lastSearchQuery: String?
    private(set) var lastSearchCategory: BookCategory?
    var searchBooksResult: Result<[Book], Error> = .success([])
    
    let booksEventSubject = PassthroughSubject<Bool, Never>()
    
    // MARK: - Create & Sort Methods
    func create(books: [BookResponseModel]) async throws -> [Book] {
        createBooksCallCount += 1
        lastCreatedBooks = books
        
        switch createBooksResult {
        case .success(let books):
            return books
        case .failure(let error):
            throw error
        }
    }
    
    func toggleFavorite(for id: String) async throws {
        toggleFavoriteCallCount += 1
        lastToggleId = id
        
        if let error = toggleFavoriteError {
            throw error
        }
    }
    
    func sortBooks(by option: SortOption) async throws -> [Book] {
        sortBooksCallCount += 1
        lastSortOption = option
        
        switch sortBooksResult {
        case .success(let books):
            return books
        case .failure(let error):
            throw error
        }
    }
    
    // MARK: - Favorites & Categories Methods
    func getFavorites() async throws -> Set<String> {
        getFavoritesCallCount += 1
        
        switch getFavoritesResult {
        case .success(let favorites):
            return favorites
        case .failure(let error):
            throw error
        }
    }
    
    func getCategories() async throws -> [BookCategory] {
        getCategoriesCallCount += 1
        
        switch getCategoriesResult {
        case .success(let categories):
            return categories
        case .failure(let error):
            throw error
        }
    }
    
    // MARK: - Book Detail & Search Methods
    func getBookDetail(by id: String) async throws -> Book? {
        getBookDetailCallCount += 1
        lastRequestedBookId = id
        
        switch getBookDetailResult {
        case .success(let book):
            return book
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
