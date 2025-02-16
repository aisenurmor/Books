//
//  HomeServiceProtocol.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Combine
import Model

public protocol HomeServiceProtocol {
    func fetchFeed(_ count: Int) -> AnyPublisher<FeedResponseModel, Error>
}
