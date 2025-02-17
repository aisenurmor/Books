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
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            
            NavigationStack(path: $coordinator.path) {
                TabView {
                    HomeBuilder.build(with: coordinator)
                        .tabItem {
                            Label("homeTitle", systemImage: "house.fill")
                        }
                    FavoritesBuilder.build(with: coordinator)
                        .tabItem {
                            Label("favoritesTitle", systemImage: "star.fill")
                        }
                }
                .navigationDestination(for: NavigationDestination.self) { screen in
                    coordinator.build(screen)
                }
            }
        }
    }
}
