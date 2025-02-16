//
//  HomeInteractor.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Combine
import Foundation
import Model
import Network
import Service

final class HomeInteractor: HomeInteractorProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    
    private let entity: HomeEntityProtocol
    private let networkService: HomeServiceProtocol
    
    init(
        entity: HomeEntityProtocol = HomeEntity(),
        networkService: HomeServiceProtocol = HomeServiceLive()
    ) {
        self.entity = entity
        self.networkService = networkService
    }
    
    func fetchBooks(_ itemCount: Int) async throws -> [Book] {
        return try await withCheckedThrowingContinuation { continuation in
            networkService.fetchFeed(itemCount)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                } receiveValue: { [weak self] response in
                    self?.entity.setBooks(response.feed.results)
                    continuation.resume(returning: response.feed.results)
                }
                .store(in: &cancellables)
        }
    }
    
    func toggleFavorite(for book: Book) async throws {
        // TODO: Add action
    }
    
    func sortBooks(by option: SortOption) -> [Book] {
        switch option {
        case .all:
            return entity.books
        case .newestToOldest:
            return entity.books.sorted { $0.releaseDate > $1.releaseDate }
        case .oldestToNewest:
            return entity.books.sorted { $0.releaseDate < $1.releaseDate }
        case .onlyLiked:
            // TODO: Add action
            return entity.books
        }
    }
}
