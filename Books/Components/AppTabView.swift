//
//  AppTabView.swift
//  Books
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Feature
import SwiftUI

struct AppTabView: View {
    
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            TabView {
                HomeBuilder.build()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                Text("Screen 2")
                    .tabItem {
                        Label("Favorites", systemImage: "star.fill")
                    }
            }
        }
    }
}
