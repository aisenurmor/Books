//
//  FavoritesInteractor.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Combine
import Model
import Repository

final class FavoritesInteractor: FavoritesInteractorProtocol {
    
    private let entity: FavoritesEntityProtocol
    private let repository: BooksRepositoryProtocol
    
    init(
        entity: FavoritesEntityProtocol = FavoritesEntity(),
        repository: BooksRepositoryProtocol
    ) {
        self.entity = entity
        self.repository = repository
    }
    
    func fetchFavorites() async throws -> [Book] {
        try await repository.sortBooks(by: .onlyLiked)
    }
    
    func toggleFavorite(for id: String) async {
        do {
            try await repository.toggleFavorite(for: id)
        } catch {
            debugPrint("An error occured when toggle favorite: \(error.localizedDescription)")
        }
    }
    
    func observeFavoritesChanges() async -> AnyPublisher<Bool, Never> {
        repository.booksEventSubject.eraseToAnyPublisher()
    }
}
