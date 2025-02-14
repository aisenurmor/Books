//
//  HomeRouter.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Model
import Navigation

final class HomeRouter: HomeRouterProtocol {
    
    private weak var coordinator: (any CoordinatorProtocol)?
    
    public init(coordinator: (any CoordinatorProtocol)?) {
        self.coordinator = coordinator
    }
    
    public func navigateToDetail(for book: Book) {
        coordinator?.push(.detail(book: book))
    }
    
    public func navigateToSearch() {
        coordinator?.push(.search)
    }
}
