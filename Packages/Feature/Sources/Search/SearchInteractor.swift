//
//  SearchInteractor.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Model
import Repository

struct SearchInteractor: SearchInteractorProtocol {
    
    private let entity: SearchEntityProtocol
    private let repository: BooksRepositoryProtocol
    
    init(
        entity: SearchEntityProtocol = SearchEntity(),
        repository: BooksRepositoryProtocol
    ) {
        self.entity = entity
        self.repository = repository
    }
    
    func getCategories() async throws -> [BookCategory] {
        try await repository.getCategories()
    }
    
    func searchBooks(query: String, category: BookCategory?) async throws -> [Book] {
        guard !query.isEmpty else { return [] }
        let books: [Book] = try await repository.searchBooks(query: query, category: category)
        return books
    }
}
