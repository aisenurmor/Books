//
//  SearchInteractorTests.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import XCTest
import Model

@testable import Feature

final class SearchInteractorTests: XCTestCase {
    private var sut: SearchInteractor!
    private var mockRepository: MockBooksRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockBooksRepository()
        sut = SearchInteractor(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func test_getCategories_shouldReturnCategories() async throws {
        let expectedCategories = [BookCategory.mock(), BookCategory.mock()]
        mockRepository.getCategoriesResult = .success(expectedCategories)
        
        let result = try await sut.getCategories()
        XCTAssertEqual(result, expectedCategories)
        XCTAssertEqual(mockRepository.getCategoriesCallCount, 1)
    }
    
    func test_getCategories_whenError_shouldThrowError() async {
        let expectedError = NSError(domain: "test", code: 1)
        mockRepository.getCategoriesResult = .failure(expectedError)
        
        do {
            _ = try await sut.getCategories()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    func test_searchBooks_shouldReturnMatchingBooks() async throws {
        let query = "Swift"
        let category = BookCategory.mock()
        let expectedBooks = [Book.mock(), Book.mock()]
        mockRepository.searchBooksResult = .success(expectedBooks)
        
        let result = try await sut.searchBooks(query: query, category: category)
        XCTAssertEqual(result, expectedBooks)
        XCTAssertEqual(mockRepository.searchBooksCallCount, 1)
        XCTAssertEqual(mockRepository.lastSearchQuery, query)
        XCTAssertEqual(mockRepository.lastSearchCategory, category)
    }
    
    func test_searchBooks_whenError_shouldThrowError() async {
        let expectedError = NSError(domain: "test", code: 1)
        mockRepository.searchBooksResult = .failure(expectedError)
        
        do {
            _ = try await sut.searchBooks(query: "test", category: nil)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
}
