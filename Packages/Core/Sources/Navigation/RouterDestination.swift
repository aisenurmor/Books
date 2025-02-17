//
//  RouterDestination.swift
//
//
//  Created by Aise Nur Mor on 15.02.2025.
//

import Foundation

public protocol RouterDestination: Hashable, Identifiable {
    var id: String { get }
    var description: String { get }
}

public extension RouterDestination {
    var id: String {
        return description
    }
} 
