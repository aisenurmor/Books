//
//  SearchPresenterTests.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import XCTest
import Combine
import Model

@testable import Feature

final class SearchPresenterTests: XCTestCase {
    private var sut: SearchPresenter!
    private var mockInteractor: MockSearchInteractor!
    private var mockRouter: MockSearchRouter!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockSearchInteractor()
        mockRouter = MockSearchRouter()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        sut = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func test_searchTextChange_shouldTriggerSearch() async {
        let expectedBooks = [Book.mock(), Book.mock()]
        mockInteractor.searchBooksResult = .success(expectedBooks)
        sut = SearchPresenter(interactor: mockInteractor, router: mockRouter)
        
        sut.searchText = "Search"
        
        let expectation = expectation(description: "Search completed")
        sut.$viewState
            .dropFirst()
            .sink { state in
                if case .loaded(let books) = state {
                    XCTAssertEqual(books, expectedBooks)
                    XCTAssertEqual(self.mockInteractor.lastSearchQuery, "Search")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation])
    }
    
    func test_navigateToDetail_shouldCallRouter() {
        sut = SearchPresenter(interactor: mockInteractor, router: mockRouter)
        let bookId = "test-id"
        
        sut.navigateToDetail(by: bookId)
        
        XCTAssertEqual(mockRouter.navigateToDetailCallCount, 1)
        XCTAssertEqual(mockRouter.lastDetailId, bookId)
    }
}
