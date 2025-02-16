//
//  File.swift
//  
//
//  Created by Aise Nur Mor on 16.02.2025.
//

import Combine
import Foundation
import Model
import Storage

public final actor BooksRepository: BooksRepositoryProtocol {
    
    public static let shared = BooksRepository()
    
    private let booksSubject = CurrentValueSubject<[Book], Never>([])
    private let storageService: FavoritesStorageProtocol
    
    public init(storageService: FavoritesStorageProtocol = FavoritesStorage()) {
        self.storageService = storageService
    }
    
    public func create(books: [BookResponseModel]) async throws -> [Book] {
        let favorites = try await getFavorites()
        
        let books = books.map { $0.toBook(isFavorite: favorites.contains($0.id)) }
        booksSubject.send(books)
        return books
    }
    
    public func toggleFavorite(for bookId: String) async throws {
        var favorites = try await getFavorites()
        
        if favorites.contains(bookId) {
            favorites.remove(bookId)
        } else {
            favorites.insert(bookId)
        }
        storageService.saveFavorites(favorites)
        update(with: bookId, isFavorite: favorites.contains(bookId))
    }
    
    public nonisolated var booksPublisher: AnyPublisher<[Book], Never> {
        booksSubject.eraseToAnyPublisher()
    }
    
    public func getFavorites() async throws -> Set<String> {
        try await storageService.getFavorites()
    }
    
    public func sortBooks(by option: SortOption) -> [Book] {
        let books = booksSubject.value
        
        switch option {
        case .all:
            return books
        case .newestToOldest:
            return books.sorted(by: { $0.publishDate > $1.publishDate })
        case .oldestToNewest:
            return books.sorted(by: { $0.publishDate < $1.publishDate })
        case .onlyLiked:
            return books.filter { $0.isFavorite }
        }
    }
}

// MARK: - Private Methods
private extension BooksRepository {
    
    private func update(with bookId: String, isFavorite: Bool) {
        guard let index = booksSubject.value.firstIndex(where: { $0.id == bookId }) else { return }
        var updatedBooks = booksSubject.value
        updatedBooks[index].isFavorite = isFavorite
        booksSubject.send(updatedBooks)
    }
}
