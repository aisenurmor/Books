//
//  MockHomeInteractor.swift
//  
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Combine
import Foundation
import Model

@testable import Feature

final class MockHomeInteractor: HomeInteractorProtocol {
    
    // MARK: - Fetch Books
    private(set) var fetchBooksCallCount = 0
    private(set) var lastFetchSortOption: SortOption?
    var fetchBooksResult: Result<[Book], Error> = .success([])
    
    func fetchBooks(with sortOption: SortOption) async throws -> [Book] {
        fetchBooksCallCount += 1
        lastFetchSortOption = sortOption
        
        switch fetchBooksResult {
        case .success(let books):
            return books
        case .failure(let error):
            throw error
        }
    }
    
    // MARK: - Toggle Favorite
    private(set) var toggleFavoriteCallCount = 0
    private(set) var lastToggleId: String?
    
    func toggleFavorite(for id: String) async {
        toggleFavoriteCallCount += 1
        lastToggleId = id
    }
    
    // MARK: - Sort Books
    private(set) var sortBooksCallCount = 0
    private(set) var lastSortOption: SortOption?
    var sortBooksResult: Result<[Book], Error> = .success([])
    
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
    
    // MARK: - Observe Favorites
    let favoritesSubject = PassthroughSubject<Bool, Never>()
    
    func observeFavoritesChanges() async -> AnyPublisher<Bool, Never> {
        favoritesSubject.eraseToAnyPublisher()
    }
}
