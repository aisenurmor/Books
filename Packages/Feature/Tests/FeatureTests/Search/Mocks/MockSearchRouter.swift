//
//  File.swift
//  
//
//  Created by Aise Nur Mor on 17.02.2025.
//

@testable import Feature

final class MockSearchRouter: SearchRouterProtocol {
    private(set) var navigateToDetailCallCount = 0
    private(set) var lastDetailId: String?
    
    func navigateToDetail(by id: String) {
        navigateToDetailCallCount += 1
        lastDetailId = id
    }
}
