//
//  FeedResponseModel.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Foundation

struct FeedResponseModel: Decodable {
    let feed: Feed
}

// MARK: - Feed
struct Feed: Decodable {
    let title: String
    let results: [Book]
}
