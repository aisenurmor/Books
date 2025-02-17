//
//  HomeInteractorTests.swift
//  
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import XCTest
import Combine
import Model

@testable import Feature

final class HomeInteractorTests: XCTestCase {
    private var sut: HomeInteractor!
    private var mockEntity: MockHomeEntity!
    private var mockRepository: MockBooksRepository!
    private var mockNetworkService: MockHomeService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockEntity = MockHomeEntity()
        mockRepository = MockBooksRepository()
        mockNetworkService = MockHomeService()
        
        sut = HomeInteractor(
            entity: mockEntity,
            repository: mockRepository,
            networkService: mockNetworkService
        )
        
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        sut = nil
        mockEntity = nil
        mockRepository = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    func test_fetchBooks_withAllSortOption_shouldFetchAndSaveBooks() async throws {
        let responseBooks = [BookResponseModel.mock(), BookResponseModel.mock()]
        let expectedBooks = responseBooks.map { $0.toBook() }
        
        mockNetworkService.fetchFeedResult = .success(FeedResponseModel(feed: Feed(title: "", results: responseBooks)))
        mockRepository.createBooksResult = .success(expectedBooks)
        
        let result = try await sut.fetchBooks(with: .all)
        XCTAssertEqual(result, expectedBooks)
        XCTAssertEqual(mockNetworkService.fetchFeedCallCount, 1)
        XCTAssertEqual(mockNetworkService.lastItemCount, 20)
        XCTAssertEqual(mockRepository.createBooksCallCount, 1)
        XCTAssertEqual(mockRepository.lastCreatedBooks, responseBooks)
    }
    
    func test_fetchBooks_withSortOption_shouldReturnSortedBooks() async throws {
        let responseBooks = [BookResponseModel.mock(), BookResponseModel.mock()]
        let sortedBooks = [Book.mock(), Book.mock()]
        let sortOption = SortOption.newestToOldest
        
        mockNetworkService.fetchFeedResult = .success(FeedResponseModel(feed: Feed(title: "", results: responseBooks)))
        mockRepository.createBooksResult = .success(responseBooks.map { $0.toBook() })
        mockRepository.sortBooksResult = .success(sortedBooks)
        
        let result = try await sut.fetchBooks(with: sortOption)
        XCTAssertEqual(result, sortedBooks)
        XCTAssertEqual(mockRepository.sortBooksCallCount, 1)
        XCTAssertEqual(mockRepository.lastSortOption, sortOption)
    }
    
    func test_fetchBooks_whenNetworkFails_shouldThrowError() async {
        let expectedError = NSError(domain: "test", code: 1)
        mockNetworkService.fetchFeedResult = .failure(expectedError)
        
        do {
            _ = try await sut.fetchBooks(with: .all)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    func test_fetchBooks_whenRepositoryFails_shouldThrowError() async {
        let responseBooks = [BookResponseModel.mock()]
        let expectedError = NSError(domain: "test", code: 1)
        
        mockNetworkService.fetchFeedResult = .success(FeedResponseModel(feed: Feed(title: "", results: responseBooks)))
        mockRepository.createBooksResult = .failure(expectedError)
        
        do {
            _ = try await sut.fetchBooks(with: .all)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    func test_toggleFavorite_shouldCallRepository() async {
        let bookId = "test-id"
        
        await sut.toggleFavorite(for: bookId)
        
        XCTAssertEqual(mockRepository.toggleFavoriteCallCount, 1)
        XCTAssertEqual(mockRepository.lastToggleId, bookId)
    }
    
    func test_toggleFavorite_whenRepositoryFails_shouldHandleError() async {
        let bookId = "test-id"
        let expectedError = NSError(domain: "test", code: 1)
        mockRepository.toggleFavoriteError = expectedError
        
        await sut.toggleFavorite(for: bookId)
        
        XCTAssertEqual(mockRepository.toggleFavoriteCallCount, 1)
    }
    
    func test_sortBooks_shouldCallRepository() async throws {
        let sortOption = SortOption.newestToOldest
        let expectedBooks = [Book.mock(), Book.mock()]
        mockRepository.sortBooksResult = .success(expectedBooks)
        
        let result = try await sut.sortBooks(by: sortOption)
        
        XCTAssertEqual(result, expectedBooks)
        XCTAssertEqual(mockRepository.sortBooksCallCount, 1)
        XCTAssertEqual(mockRepository.lastSortOption, sortOption)
    }
    
    func test_sortBooks_whenRepositoryFails_shouldThrowError() async {
        let expectedError = NSError(domain: "test", code: 1)
        mockRepository.sortBooksResult = .failure(expectedError)
        
        do {
            _ = try await sut.sortBooks(by: .newestToOldest)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    // MARK: - Observe Favorites Tests
    func test_observeFavoritesChanges_shouldReturnRepositoryPublisher() async {
        let expectedValue = true
        let publisher = await sut.observeFavoritesChanges()
        let expectation = expectation(description: "Favorites changes received")
        
        publisher
            .sink { value in
                XCTAssertEqual(value, expectedValue)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        mockRepository.booksEventSubject.send(expectedValue)
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
