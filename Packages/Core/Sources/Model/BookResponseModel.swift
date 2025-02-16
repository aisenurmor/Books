//
//  BookResponseModel.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Foundation
import Helper

public struct BookResponseModel: Codable {
    
    let id: String
    let name: String
    let artistName: String
    let releaseDate: String
    let kind: Kind
    let artistId: String
    let artistUrl: String
    let artworkUrl100: String
    let genres: [Genre]
    let url: String
    let contentAdvisoryRating: String?
    
    public func toBook(isFavorite: Bool = false) -> Book {
        Book(
            id: id,
            title: name,
            author: artistName,
            imageUrl: artworkUrl100,
            publishDate: DateFormatter.booksFormatter.date(from: releaseDate) ?? Date(),
            isFavorite: isFavorite,
            category: genres.compactMap { $0.toBookCategory() }
        )
    }
}

// MARK: - Genre
public struct Genre: Codable {
    
    let genreId: String
    let name: String
    let url: String
    
    func toBookCategory() -> BookCategory {
        BookCategory(id: genreId, name: name)
    }
}

// MARK: - Kind
public enum Kind: String, Codable {
    case books = "books"
}
