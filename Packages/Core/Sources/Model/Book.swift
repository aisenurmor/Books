//
//  Book.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Foundation

struct Book: Decodable {
    let id: String
    let name: String
    let artistName: String
    let releaseDate: String
    let kind: Kind
    let artistId: String
    let artistURL: String
    let imageURL: String
    let genres: [Genre]
    let url: String
    let contentAdvisoryRating: String?
    
    enum CodingKeys: String, CodingKey {
        case artistName, id, name, releaseDate, kind
        case artistId = "artistId"
        case artistURL
        case imageURL = "artworkUrl100"
        case genres, url, contentAdvisoryRating
    }
}

// MARK: - Genre
struct Genre: Codable {
    let genreId: String
    let name: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case genreId = "genreID"
        case name, url
    }
}

// MARK: - Kind
enum Kind: String, Codable {
    case books = "books"
}
