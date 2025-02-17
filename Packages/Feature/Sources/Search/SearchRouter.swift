//
//  SearchRouter.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Model
import Navigation

final class SearchRouter: SearchRouterProtocol {
    
    private weak var coordinator: (any CoordinatorProtocol)?
    
    public init(coordinator: (any CoordinatorProtocol)?) {
        self.coordinator = coordinator
    }
    
    public func navigateToDetail(for book: Book) {
        coordinator?.push(.detail(book: book))
    }
}
