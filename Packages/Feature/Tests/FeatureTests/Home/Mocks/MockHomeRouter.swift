//
//  MockHomeRouter.swift
//  
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import XCTest

@testable import Feature

final class MockHomeRouter: HomeRouterProtocol {
    
    private(set) var navigateToSearchCallCount = 0
    private(set) var navigateToDetailCallCount = 0
    
    func navigateToSearch() {
        navigateToSearchCallCount += 1
    }
    
    func navigateToDetail(by id: String) {
        navigateToDetailCallCount += 1
    }
}
