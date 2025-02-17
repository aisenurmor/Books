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
    
    init(coordinator: (any CoordinatorProtocol)?) {
        self.coordinator = coordinator
    }
    
    func navigateToDetail(by id: String) {
        coordinator?.push(.detail(id: id))
    }
}
