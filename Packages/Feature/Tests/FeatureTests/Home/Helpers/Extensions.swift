//
//  File.swift
//  
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Model
import UICore

@testable import Feature

// MARK: - ViewState Equatable
extension ViewState: Equatable where T: Equatable {
    public static func == (lhs: ViewState<T>, rhs: ViewState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.loaded(let lhsState), .loaded(let rhsState)):
            return lhsState == rhsState
        case (.error(let lhsMessage), .error(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

// MARK: - Book Equatable
extension Book: Equatable {
    public static func == (lhs: Book, rhs: Book) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.author == rhs.author &&
        lhs.publishDate == rhs.publishDate &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.category == rhs.category
    }
}

// MARK: - BookResponseModel Equatable
extension BookResponseModel: Equatable {
    public static func == (lhs: BookResponseModel, rhs: BookResponseModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.artistName == rhs.artistName &&
        lhs.releaseDate == rhs.releaseDate &&
        lhs.kind == rhs.kind &&
        lhs.artistId == rhs.artistId &&
        lhs.artistUrl == rhs.artistUrl &&
        lhs.artworkUrl100 == rhs.artworkUrl100 &&
        lhs.genres == rhs.genres &&
        lhs.url == rhs.url &&
        lhs.contentAdvisoryRating == rhs.contentAdvisoryRating
    }
}

// MARK: - Genre Equatable
extension Genre: Equatable {
    public static func == (lhs: Genre, rhs: Genre) -> Bool {
        lhs.genreId == rhs.genreId &&
        lhs.name == rhs.name &&
        lhs.url == rhs.url
    }
}

// MARK: - HomeState Equatable
extension HomeState: Equatable {
    public static func == (lhs: HomeState, rhs: HomeState) -> Bool {
        lhs.isPaginationLoading == rhs.isPaginationLoading &&
        lhs.isEndOfList == rhs.isEndOfList &&
        lhs.books == rhs.books
    }
}
