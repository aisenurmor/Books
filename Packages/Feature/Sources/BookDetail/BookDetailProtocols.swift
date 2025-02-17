//
//  BookDetailProtocols.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Foundation
import Model

// MARK: View Protocol
protocol BookDetailViewProtocol {
    var presenter: any BookDetailPresenterProtocol { get }
}

// MARK: - Presenter Protocol
protocol BookDetailPresenterProtocol: ObservableObject { }

// MARK: - Interactor Protocol
protocol BookDetailInteractorProtocol {
    func toggleFavorite(for book: Book) async throws
    func getBookDetail(by id: String) async throws -> Book?
}

// MARK: - Router Protocol
protocol BookDetailRouterProtocol { }

// MARK: - Entity Protocol
protocol BookDetailEntityProtocol { }
