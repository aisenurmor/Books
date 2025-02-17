//
//  FeedResponseModel.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Foundation

public struct FeedResponseModel: Decodable {
    public let feed: Feed
    
    public init(feed: Feed) {
        self.feed = feed
    }
}

// MARK: - Feed
public struct Feed: Decodable {
    
    public let title: String
    public let results: [BookResponseModel]
    
    public init(title: String, results: [BookResponseModel]) {
        self.title = title
        self.results = results
    }
}
