//
//  HomeServiceLive.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Combine
import Model
import Network

public struct HomeServiceLive: HomeServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    public init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    public func fetchFeed(_ count: Int) -> AnyPublisher<FeedResponseModel, Error> {
        let requestBuilder = ApiRequestBuilder(endpoint: .feed(count: count), httpMethod: .get)

        return networkService.performRequest(with: requestBuilder, decodingType: FeedResponseModel.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}
