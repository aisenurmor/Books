//
//  Book+Mock.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Foundation
import Model

extension Book {
    
    static func mock(
        id: String = "test-id",
        name: String = "Test Book",
        artistName: String = "Test Author",
        releaseDate: String = "2024-01-01",
        kind: Kind = .books,
        artistId: String = "test-artist",
        artistUrl: String = "https://test.com/artist",
        imageUrl: String = "https://test.com/image",
        genres: [Genre] = [],
        url: String = "https://test.com/book",
        contentAdvisoryRating: String? = nil
    ) -> Book {
        Book(
            id: id,
            title: name, 
            author: artistName,
            imageUrl: imageUrl,
            publishDate: Date(),
            isFavorite: true,
            category: genres.map { $0.toBookCategory() }
        )
    }
}
