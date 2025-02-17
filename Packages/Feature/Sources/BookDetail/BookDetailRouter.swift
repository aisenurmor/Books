//
//  BookDetailRouter.swift
//  
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Model
import Navigation

final class BookDetailRouter: BookDetailRouterProtocol {
    
    private weak var coordinator: (any CoordinatorProtocol)?
    
    init(coordinator: (any CoordinatorProtocol)?) {
        self.coordinator = coordinator
    }
}

