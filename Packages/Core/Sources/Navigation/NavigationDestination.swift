//
//  NavigationDestination.swift
//
//
//  Created by Aise Nur Mor on 15.02.2025.
//

import Foundation
import Model

public enum NavigationDestination: RouterDestination {
    case detail(book: Book)
    case search
    case favorites
    
    public var description: String {
        switch self {
        case .detail(let book):
            return "detail-\(book.id)"
        case .search:
            return "search"
        case .favorites:
            return "favorites"
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }
    
    public static func == (lhs: NavigationDestination, rhs: NavigationDestination) -> Bool {
        lhs.description == rhs.description
    }
}
