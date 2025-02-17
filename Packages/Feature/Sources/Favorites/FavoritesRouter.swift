//
//  FavoritesRouter.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//


import Navigation

final class FavoritesRouter: FavoritesRouterProtocol {
    
    private weak var coordinator: (any CoordinatorProtocol)?
    
    public init(coordinator: (any CoordinatorProtocol)?) {
        self.coordinator = coordinator
    }
    
    public func navigateToDetail(by id: String) {
        coordinator?.push(.detail(id: id))
    }
}
