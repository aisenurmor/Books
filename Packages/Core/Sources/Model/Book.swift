//
//  File.swift
//  
//
//  Created by Aise Nur Mor on 16.02.2025.
//

import Foundation

public struct Book: Identifiable {
    
    public let id: String
    public let title: String
    public let author: String
    public let imageUrl: String
    public let publishDate: Date
    public var isFavorite: Bool
    public let category: [BookCategory]
    
    public init(
        id: String,
        title: String,
        author: String,
        imageUrl: String,
        publishDate: Date,
        isFavorite: Bool = false,
        category: [BookCategory]
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.imageUrl = imageUrl
        self.publishDate = publishDate
        self.isFavorite = isFavorite
        self.category = category
    }
}

// MARK: - BookCategory
public struct BookCategory: Identifiable, Hashable {
    public let id: String
    public let name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
