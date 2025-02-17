//
//  BookDetailPresenter.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Combine
import Foundation
import Model
import UICore

final class BookDetailPresenter: BookDetailPresenterProtocol {
    
    @Published var error: Error?
    @Published private(set) var viewState: ViewState<Book> = .loading
    
    private let bookId: String
    private let interactor: BookDetailInteractorProtocol
    private let router: BookDetailRouterProtocol
    
    var publishedDate: String {
        guard case .loaded(let book) = viewState else { return "" }
        return "publishedDate".localized(with: book.publishDate.fullDateFormat)
    }
    
    var authorName: String {
        guard case .loaded(let book) = viewState else { return "" }
        return "authorBy".localized(with: book.author)
    }
    
    init(
        bookId: String,
        interactor: BookDetailInteractorProtocol,
        router: BookDetailRouterProtocol
    ) {
        self.bookId = bookId
        self.interactor = interactor
        self.router = router
        
        getBookDetail()
    }
    
    func toggleFavorite() async throws  {
        guard case .loaded(let book) = viewState else {
            throw BookDetailError.bookNotLoaded
        }
        
        do {
            try await interactor.toggleFavorite(for: book)
            
            await MainActor.run {
                if case .loaded(var updatedBook) = viewState {
                    updatedBook.isFavorite.toggle()
                    viewState = .loaded(updatedBook)
                }
            }
        } catch {
            await MainActor.run {
                self.error = error
            }
            throw error
        }
    }
    
    func retry() {
        viewState = .loading
        getBookDetail()
    }
}

// MARK: - Private Methods
private extension BookDetailPresenter {
    
    func getBookDetail() {
        Task {
            await loadBookDetail(bookId: bookId)
        }
    }
    
    func loadBookDetail(bookId: String) async {
        do {
            if let detail = try await interactor.getBookDetail(by: bookId) {
                await MainActor.run {
                    viewState = .loaded(detail)
                    error = nil
                }
            }
        } catch {
            await MainActor.run {
                viewState = .error(message: "loadBookDetailsFailedMessage".localized)
                self.error = error
            }
        }
    }
}

// MARK: - Errors
fileprivate enum BookDetailError: LocalizedError {
    case bookNotLoaded
    
    var errorDescription: String? {
        switch self {
        case .bookNotLoaded:
            return "Cannot perform action - book details not yet loaded"
        }
    }
}
