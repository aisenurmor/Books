//
//  AppTabView.swift
//  Books
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Feature
import Navigation
import SwiftUI

struct AppTabView: View {
    
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            TabView {
                HomeBuilder.build(with: coordinator)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                Text("Screen 2")
                    .tabItem {
                        Label("Favorites", systemImage: "star.fill")
                    }
            }
            .navigationDestination(for: NavigationDestination.self) { screen in
                coordinator.build(screen)
            }
        }
    }
}
