//
//  HomeInteractor.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Foundation
import Model
import Network

final class HomeInteractor: HomeInteractorProtocol {
    
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
        // TODO: Add action
        return []
    }
    
    func toggleFavorite(for book: Book) async throws {
        // TODO: Add action
    }
}
