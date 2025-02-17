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
        repository: BooksRepositoryProtocol,
        networkService: HomeServiceProtocol = HomeServiceLive()
    ) {
        self.entity = entity
        self.repository = repository
        self.networkService = networkService
    }
    
    func fetchBooks(with sortOption: SortOption) async throws -> [Book] {
        let itemCount = currentPage * pageSize
        
        let books = try await fetchBooksFromNetwork(itemCount)
        let savedBooks = try await saveBooksToRepository(books)
        
        if sortOption != .all {
            return try await sortBooks(by: sortOption)
        }
        
        currentPage += 1
        return savedBooks
    }
    
    func toggleFavorite(for id: String) async {
        do {
            try await repository.toggleFavorite(for: id)
        } catch {
            debugPrint("An error occured when toggle favorite: \(error.localizedDescription)")
        }
    }
    
    func sortBooks(by option: SortOption) async throws -> [Book] {
        return try await repository.sortBooks(by: option)
    }
    
    func observeFavoritesChanges() async -> AnyPublisher<Bool, Never> {
        repository.booksEventSubject.eraseToAnyPublisher()
    }
}

// MARK: - Private Methods
private extension HomeInteractor {
    
    func fetchBooksFromNetwork(_ itemCount: Int) async throws -> [BookResponseModel] {
        try await withCheckedThrowingContinuation { continuation in
            networkService.fetchFeed(itemCount)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case .failure(let error) = completion {
                        continuation.resume(throwing: error)
                    }
                } receiveValue: { response in
                    continuation.resume(returning: response.feed.results)
                }
                .store(in: &cancellables)
        }
    }
    
    func saveBooksToRepository(_ books: [BookResponseModel]) async throws -> [Book] {
        return try await repository.create(books: books)
    }
}
