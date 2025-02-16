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
    private let storageService: FavoritesStorage
    
    public init(storageService: FavoritesStorage = FavoritesStorage()) {
        self.storageService = storageService
    }
    
    public func create(books: [BookResponseModel]) async throws  -> [Book] {
        let favorites = try await getFavorites()
        
        booksSubject.value = books.map { result in
            let book = result.toBook()
            return Book(
                id: book.id,
                title: book.title,
                author: book.author,
                imageUrl: book.imageUrl,
                publishDate: book.publishDate,
                isFavorite: favorites.contains(book.id),
                category: book.category
            )
        }
        
        return booksSubject.value
    }
    
    public func toggleFavorite(for bookId: String) async throws {
        var favorites = try await getFavorites()
        
        if favorites.contains(bookId) {
            favorites.remove(bookId)
        } else {
            favorites.insert(bookId)
        }
        
        storageService.saveFavorites(favorites)
        
        booksSubject.value = booksSubject.value.map { book in
            if book.id == bookId {
                return Book(
                    id: book.id,
                    title: book.title,
                    author: book.author,
                    imageUrl: book.imageUrl,
                    publishDate: book.publishDate,
                    isFavorite: favorites.contains(book.id),
                    category: book.category
                )
            }
            return book
        }
    }
    
    public nonisolated var booksPublisher: AnyPublisher<[Book], Never> {
        booksSubject.eraseToAnyPublisher()
    }
    
    public func getFavorites() async throws -> Set<String> {
        try await storageService.getFavorites()
    }
    
    public func sortBooks(by option: SortOption) async throws -> [Book] {
        switch option {
        case .all:
            return booksSubject.value
        case .newestToOldest:
            return booksSubject.value.sorted { $0.publishDate > $1.publishDate }
        case .oldestToNewest:
            return booksSubject.value.sorted { $0.publishDate < $1.publishDate }
        case .onlyLiked:
            return booksSubject.value.filter { $0.isFavorite }
        }
    }
}
