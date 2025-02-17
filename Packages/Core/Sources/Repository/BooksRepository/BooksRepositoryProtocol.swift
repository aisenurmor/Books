//
//  BooksRepositoryProtocol.swift
//  
//
//  Created by Aise Nur Mor on 16.02.2025.
//

import Combine
import Model

public protocol BooksRepositoryProtocol {
    var booksPublisher: AnyPublisher<[Book], Never> { get }
    
    func create(books: [BookResponseModel]) async throws -> [Book]
    func toggleFavorite(for bookId: String) async throws
    func getFavorites() async throws -> Set<String>
    func sortBooks(by option: SortOption) async throws -> [Book]
    func getCategories() async throws -> [BookCategory]
    func getBookDetail(by id: String) async throws -> Book?
    func searchBooks(query: String, category: BookCategory?) async throws -> [Book]
}
