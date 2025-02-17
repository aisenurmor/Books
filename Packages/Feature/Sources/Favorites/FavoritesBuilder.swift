//
//  FavoritesBuilder.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Navigation
import NetworkService
import Repository
import SwiftUI

public enum FavoritesBuilder {
    
    public static func build(with coordinator: any CoordinatorProtocol) -> some View {
        let entity: FavoritesEntityProtocol = FavoritesEntity()
        let interactor = FavoritesInteractor(
            entity: entity,
            repository: BooksRepository.shared
        )
        let router = FavoritesRouter(coordinator: coordinator)
        let presenter = FavoritesPresenter(
            interactor: interactor,
            router: router
        )
        
        return FavoritesView(presenter: presenter)
    }
}

