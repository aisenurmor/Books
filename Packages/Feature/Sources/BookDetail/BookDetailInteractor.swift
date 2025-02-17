//
//  BookDetailInteractor.swift
//  
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Model
import Repository

struct BookDetailInteractor: BookDetailInteractorProtocol {
    
    private let entity: BookDetailEntityProtocol
    private let repository: BooksRepositoryProtocol
    
    init(
        entity: BookDetailEntityProtocol = BookDetailEntity(),
        repository: BooksRepositoryProtocol
    ) {
        self.entity = entity
        self.repository = repository
    }
    
    func getBookDetail(by id: String) async throws -> Book? {
        try await repository.getBookDetail(by: id)
    }
    
    func toggleFavorite(for book: Book) async throws {
        try await repository.toggleFavorite(for: book.id)
    }
}
