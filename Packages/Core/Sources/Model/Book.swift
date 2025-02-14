//
//  Book.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Foundation

public struct Book: Decodable {
    
    public let id: String
    public let name: String
    public let artistName: String
    public let releaseDate: String
    public let kind: Kind
    public let artistId: String
    public let artistURL: String
    public let imageURL: String
    public let genres: [Genre]
    public let url: String
    public let contentAdvisoryRating: String?
    
    enum CodingKeys: String, CodingKey {
        case artistName, id, name, releaseDate, kind
        case artistId = "artistId"
        case artistURL
        case imageURL = "artworkUrl100"
        case genres, url, contentAdvisoryRating
    }
}

// MARK: - Genre
public struct Genre: Codable {
    public let genreId: String
    public let name: String
    public let url: String

    enum CodingKeys: String, CodingKey {
        case genreId = "genreID"
        case name, url
    }
}

// MARK: - Kind
public enum Kind: String, Codable {
    case books = "books"
}
