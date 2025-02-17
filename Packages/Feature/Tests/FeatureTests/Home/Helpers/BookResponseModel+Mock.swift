//
//  BookResponseModel+Mock.swift
//  
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Foundation
import Model

extension BookResponseModel {
    static func mock(
        id: String = "test-id",
        name: String = "Test Book",
        artistName: String = "Test Author",
        releaseDate: String = "2024-01-01",
        kind: Kind = .books,
        artistId: String = "test-artist-id",
        artistUrl: String = "https://test.com/artist",
        imageUrl: String = "https://test.com/image",
        genres: [Genre] = [.mock()],
        url: String = "https://test.com/book",
        contentAdvisoryRating: String? = nil
    ) -> BookResponseModel {
        BookResponseModel(
            id: id,
            name: name,
            artistName: artistName,
            releaseDate: releaseDate,
            kind: kind,
            artistId: artistId,
            artistUrl: artistUrl,
            artworkUrl100: imageUrl,
            genres: genres,
            url: url,
            contentAdvisoryRating: contentAdvisoryRating
        )
    }
}

// MARK: - Genre Mock
extension Genre {
    static func mock(
        genreId: String = "test-genre-id",
        name: String = "Test Genre",
        url: String = "https://test.com/genre"
    ) -> Genre {
        Genre(
            genreId: genreId,
            name: name,
            url: url
        )
    }
}

// MARK: - Feed Mock
extension Feed {
    static func mock(
        title: String = "Test Feed",
        results: [BookResponseModel] = [.mock()]
    ) -> Feed {
        Feed(
            title: title,
            results: results
        )
    }
}

// MARK: - FeedResponse Mock
extension FeedResponseModel {
    static func mock(
        feed: Feed = .mock()
    ) -> FeedResponseModel {
        FeedResponseModel(feed: feed)
    }
}

// MARK: - BookCategory Mock
extension BookCategory {
    static func mock(
        id: String = "test-category-id",
        name: String = "Test Category"
    ) -> BookCategory {
        BookCategory(
            id: id,
            name: name
        )
    }
}
