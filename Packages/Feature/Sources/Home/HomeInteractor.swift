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
    
    func fetchBooks() async throws -> [Book] {
        return try await withCheckedThrowingContinuation { continuation in
            networkService.fetchFeed(100)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                } receiveValue: { response in
                    continuation.resume(returning: response.feed.results)
                }
                .store(in: &cancellables)
        }
    }
    
    func toggleFavorite(for book: Book) async throws {
        // TODO: Add action
    }
    
    func sortBooks(books: [Book], by option: SortOption) -> [Book] {
        switch option {
        case .all:
            return books
        case .newestToOldest:
            return books.sorted { $0.releaseDate > $1.releaseDate }
        case .oldestToNewest:
            return books.sorted { $0.releaseDate < $1.releaseDate }
        case .onlyLiked:
            // TODO: Add action
            return books
        }
    }
}
