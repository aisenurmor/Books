//
//  SortOption.swift
//
//
//  Created by Aise Nur Mor on 16.02.2025.
//

public enum SortOption: CaseIterable {
    case all
    case newestToOldest
    case oldestToNewest
    case onlyLiked
    
    public var title: String {
        return switch self {
        case .all:
            "sortOptionAll"
        case .newestToOldest:
            "sortOptionNewestToOldest"
        case .oldestToNewest:
            "sortOptionOldestToNewest"
        case .onlyLiked:
            "sortOptionOnlyLiked"
        }
    }
}
