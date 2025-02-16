//
//  FavoritesStorage.swift
//
//
//  Created by Aise Nur Mor on 16.02.2025.
//

import Foundation

public struct FavoritesStorage {
    
    private let defaults = UserDefaults.standard
    private let favoritesKey = "favoriteBooks"
    
    public init() { }
    
    public func saveFavorites(_ favorites: Set<String>) {
        do {
            let data = try JSONEncoder().encode(Array(favorites))
            defaults.set(data, forKey: favoritesKey)
        } catch {
            debugPrint("Failed to save favorites: \(error)")
        }
    }
    
    public func getFavorites() async throws -> Set<String> {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey) else {
            return []
        }
        return try JSONDecoder().decode(Set<String>.self, from: data)
    }
}
