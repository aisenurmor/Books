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
    
    private let pageSize = 20
    private var currentPage = 1
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
    
    func fetchMoreBooks() async throws -> [Book] {
        currentPage += 1
        let itemCount = currentPage * pageSize
        
        let newBooks = try await fetchBooksFromNetwork(itemCount)
        let savedBooks = try await saveBooksToRepository(newBooks)
        
        return savedBooks
    }
    
    func refreshBooks() async throws -> [Book] {
        currentPage = 1
        return try await fetchBooks(pageSize)
    }
    
    func toggleFavorite(for id: String) async throws {
        try await repository.toggleFavorite(for: id)
    }
    
    func sortBooks(by option: SortOption) async throws -> [Book] {
        return try await repository.sortBooks(by: option)
    }
    
    func observeFavorites() async -> AnyPublisher<[Book], Never> {
        repository.booksSubject.eraseToAnyPublisher()
    }
}

// MARK: - Private Methods
private extension HomeInteractor {
    
    func fetchBooks(_ itemCount: Int) async throws -> [Book] {
        let books = try await fetchBooksFromNetwork(itemCount)
        return try await saveBooksToRepository(books)
    }
    
    func fetchBooksFromNetwork(_ itemCount: Int) async throws -> [BookResponseModel] {
        try await withCheckedThrowingContinuation { continuation in
            networkService.fetchFeed(itemCount)
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
    
    func saveBooksToRepository(_ books: [BookResponseModel]) async throws -> [Book] {
        do {
            return try await repository.create(books: books)
        } catch {
            throw error
        }
    }
}
