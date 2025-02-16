//
//  Book.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Foundation

public struct Book: Codable {
    
    public let id: String
    public let name: String
    public let artistName: String
    public let releaseDate: String
    public let kind: Kind
    public let artistId: String
    public let artistUrl: String
    public let imageUrl: String
    public let genres: [Genre]
    public let url: String
    public let contentAdvisoryRating: String?
    
    enum CodingKeys: String, CodingKey {
        case artistName, id, name, releaseDate, kind
        case artistId = "artistId"
        case artistUrl
        case imageUrl = "artworkUrl100"
        case genres, url, contentAdvisoryRating
    }
}

// MARK: - Genre
public struct Genre: Codable {
    
    public let genreId: String
    public let name: String
    public let url: String
}

// MARK: - Kind
public enum Kind: String, Codable {
    case books = "books"
}
