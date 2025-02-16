//
//  HomeEntity.swift
//  
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Foundation

enum SortOption: CaseIterable {
    case all
    case newestToOldest
    case oldestToNewest
    case onlyLiked
    
    var title: String {
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

final class HomeEntity: HomeEntityProtocol { }
