//
//  HomeInteractor.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Combine
import Foundation
import Model
import NetworkService
import Repository

final class HomeInteractor: HomeInteractorProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    
    private let entity: HomeEntityProtocol
    private let repository: BooksRepositoryProtocol
    private let networkService: HomeServiceProtocol
    
    init(
        entity: HomeEntityProtocol = HomeEntity(),
        repository: BooksRepositoryProtocol = BooksRepository(),
        networkService: HomeServiceProtocol = HomeServiceLive()
    ) {
        self.entity = entity
        self.repository = repository
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
                    guard let self else { return }
                    Task {
                        do {
                            let books = try await self.repository.create(books: response.feed.results)
                            continuation.resume(returning: books)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    func toggleFavorite(for id: String) async throws {
        try await repository.toggleFavorite(for: id)
    }
    
    func sortBooks(by option: SortOption) async throws -> [Book] {
        return try await repository.sortBooks(by: option)
    }
    
    func getFavoriteIds() async throws -> Set<String> {
        try await repository.getFavorites()
    }
    
    func observeFavorites() async -> AnyPublisher<[Book], Never> {
        repository.booksPublisher
    }
}
