//
//  BookResponseModel.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Foundation
import Helper

public struct BookResponseModel: Codable {
    
    public let id: String
    public let name: String
    public let artistName: String
    public let releaseDate: String
    public let kind: Kind
    public let artistId: String
    public let artistUrl: String
    public let artworkUrl100: String
    public let genres: [Genre]
    public let url: String
    public let contentAdvisoryRating: String?
    
    public init(
        id: String,
        name: String,
        artistName: String,
        releaseDate: String,
        kind: Kind,
        artistId: String,
        artistUrl: String,
        artworkUrl100: String,
        genres: [Genre],
        url: String,
        contentAdvisoryRating: String?
    ) {
        self.id = id
        self.name = name
        self.artistName = artistName
        self.releaseDate = releaseDate
        self.kind = kind
        self.artistId = artistId
        self.artistUrl = artistUrl
        self.artworkUrl100 = artworkUrl100
        self.genres = genres
        self.url = url
        self.contentAdvisoryRating = contentAdvisoryRating
    }
    
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
    
    public let genreId: String
    public let name: String
    public let url: String
    
    public init(genreId: String, name: String, url: String) {
        self.genreId = genreId
        self.name = name
        self.url = url
    }
    
    public func toBookCategory() -> BookCategory {
        BookCategory(id: genreId, name: name)
    }
}

// MARK: - Kind
public enum Kind: String, Codable {
    case books = "books"
}
