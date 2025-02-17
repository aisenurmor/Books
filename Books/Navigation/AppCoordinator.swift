//
//  AppCoordinator.swift
//  Books
//
//  Created by Aise Nur Mor on 15.02.2025.
//

import Feature
import Navigation
import SwiftUI

final class AppCoordinator: CoordinatorProtocol {
    
    // MARK: - Properties
    @Published var path: NavigationPath = NavigationPath()
    
    // MARK: - Navigation Functions
    func push(_ destination: NavigationDestination) {
        path.append(destination)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func build(_ destination: NavigationDestination) -> some View {
        switch destination {
        case .detail(let id):
            BookDetailBuilder.build(with: id, coordinator: self)
        case .favorites:
            FavoritesBuilder.build(with: self)
        case .search:
            SearchBuilder.build(with: self)
        }
    }
}
