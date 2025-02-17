//
//  HomePresenterTests.swift
//  
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Combine
import Model
import XCTest
import UICore

@testable import Feature

final class HomePresenterTests: XCTestCase {
    private var sut: HomePresenter!
    private var mockInteractor: MockHomeInteractor!
    private var mockRouter: MockHomeRouter!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockHomeInteractor()
        mockRouter = MockHomeRouter()
        sut = HomePresenter(
            interactor: mockInteractor,
            router: mockRouter
        )
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        sut = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_whenStateIsLoading_shouldFetchBooks() async {
        let expectedBooks = [Book.mock(), Book.mock()]
        mockInteractor.fetchBooksResult = .success(expectedBooks)
        
        sut.viewDidLoad()
        
        let expectation = expectation(description: "Books loaded")
        sut.$viewState
            .dropFirst()
            .sink { state in
                if case .loaded(let homeState) = state {
                    XCTAssertEqual(homeState.books, expectedBooks)
                    XCTAssertFalse(homeState.isPaginationLoading)
                    XCTAssertFalse(homeState.isEndOfList)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(mockInteractor.fetchBooksCallCount, 1)
        XCTAssertEqual(mockInteractor.lastFetchSortOption, .all)
    }
    
    func test_viewDidLoad_whenError_shouldUpdateStateWithError() async {
        let error = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockInteractor.fetchBooksResult = .failure(error)
        
        sut.viewDidLoad()
        
        let expectation = expectation(description: "Error state")
        sut.$viewState
            .dropFirst()
            .sink { state in
                if case .error(let message) = state {
                    XCTAssertEqual(message, error.localizedDescription)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func test_sort_whenNewOption_shouldUpdateSortOptionAndFetchBooks() async {
        let sortedBooks = [Book.mock(), Book.mock()]
        mockInteractor.sortBooksResult = .success(sortedBooks)
        
        sut.sort(by: .newestToOldest)
        
        let expectation = expectation(description: "Books sorted")
        sut.$viewState
            .dropFirst()
            .sink { state in
                if case .loaded(let homeState) = state {
                    XCTAssertEqual(homeState.books, sortedBooks)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.selectedSortOption, .newestToOldest)
    }
}

