//
//  MockHomeService.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Combine
import Foundation
import Model

@testable import Feature

final class MockHomeService: HomeServiceProtocol {
    private(set) var fetchFeedCallCount = 0
    private(set) var lastItemCount: Int?
    var fetchFeedResult: Result<FeedResponseModel, Error> = .success(FeedResponseModel(feed: Feed(title: "", results: [])))
    
    func fetchFeed(_ itemCount: Int) -> AnyPublisher<FeedResponseModel, Error> {
        fetchFeedCallCount += 1
        lastItemCount = itemCount
        
        return Future { promise in
            promise(self.fetchFeedResult)
        }.eraseToAnyPublisher()
    }
}
