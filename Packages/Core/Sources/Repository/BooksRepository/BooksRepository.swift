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
    
    public let booksEventSubject: PassthroughSubject<Bool, Never> = .init()
    
    private var books: [Book] = []
    private var booksById: [String: Int] = [:]
    private var cachedCategories: [BookCategory]?
    private var cachedSortedBooks: [SortOption: [Book]] = [:]
    
    private let storageService: FavoritesStorageProtocol
    
    init(storageService: FavoritesStorageProtocol = FavoritesStorage()) {
        self.storageService = storageService
    }
    
    public func create(books: [BookResponseModel]) async throws -> [Book] {
        let favorites = try await getFavorites()
        let booksList = books.map { $0.toBook(isFavorite: favorites.contains($0.id)) }
        self.books = booksList
        rebuildIndexCache()
        invalidateCaches()
        return self.books
    }
    
    public func toggleFavorite(for bookId: String) async throws {
        let favorites = try await getFavorites()
        let isFavorite = favorites.contains(bookId)
        var updatedFavorites = favorites
        
        if isFavorite {
            updatedFavorites.remove(bookId)
        } else {
            updatedFavorites.insert(bookId)
        }
        
        storageService.saveFavorites(updatedFavorites)
        update(with: bookId, isFavorite: !isFavorite)
        
        invalidateSortedCache()
    }
    
    public func getFavorites() async throws -> Set<String> {
        try await storageService.getFavorites()
    }
    
    public func getBookDetail(by id: String) async throws -> Book? {
        guard let index = booksById[id] else { return nil }
        return books[index]
    }
    
    public func sortBooks(by option: SortOption) -> [Book] {
        if let cached = cachedSortedBooks[option] {
            return cached
        }
        
        let sorted: [Book]
        switch option {
        case .all:
            sorted = books
        case .newestToOldest:
            sorted = books.sorted(by: {
                guard $0.publishDate != $1.publishDate else {
                    return $0.title < $1.title
                }
                return $0.publishDate > $1.publishDate
            })
        case .oldestToNewest:
            sorted = books.sorted(by: {
                guard $0.publishDate != $1.publishDate else {
                    return $0.title < $1.title
                }
                return $0.publishDate < $1.publishDate
            })
        case .onlyLiked:
            sorted = books.filter { $0.isFavorite }
        }
        
        cachedSortedBooks[option] = sorted
        return sorted
    }
    
    public func getCategories() async throws -> [BookCategory] {
        if let cachedCategories {
            return cachedCategories
        }
        
        let allCategories = books.flatMap { $0.category }
        let uniqueCategories = Array(Set(allCategories))
        cachedCategories = uniqueCategories
        return uniqueCategories
    }
    
    public func searchBooks(query: String, category: BookCategory?) async throws  -> [Book] {
        guard !query.isEmpty else { return [] }
        
        let lowercasedQuery = query.lowercased()
        return books.filter { book in
            if let category {
                return book.category.contains(category)
            }
            
            let lowercasedTitle = book.title.lowercased()
            return lowercasedTitle.hasPrefix(lowercasedQuery) ||
            lowercasedTitle.contains(lowercasedQuery)
        }
    }
}

// MARK: - Private Methods
private extension BooksRepository {
    
    func update(with bookId: String, isFavorite: Bool) {
        guard let index = booksById[bookId] else { return }
        
        books[index].isFavorite = isFavorite
        booksEventSubject.send(true)
    }
    
    func rebuildIndexCache() {
        booksById = Dictionary(uniqueKeysWithValues: books.enumerated().map { ($1.id, $0) })
    }
    
    func invalidateCaches() {
        cachedCategories = nil
        invalidateSortedCache()
    }
    
    func invalidateSortedCache() {
        cachedSortedBooks.removeAll()
    }
}
