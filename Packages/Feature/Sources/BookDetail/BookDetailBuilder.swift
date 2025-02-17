//
//  BookDetailBuilder.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Model
import Navigation
import Repository
import SwiftUI

public enum BookDetailBuilder {
    
    public static func build(with bookId: String, coordinator: any CoordinatorProtocol) -> some View {
        let entity = BookDetailEntity()
        let repository = BooksRepository.shared
        let interactor = BookDetailInteractor(entity: entity, repository: repository)
        let router = BookDetailRouter(coordinator: coordinator)
        let presenter = BookDetailPresenter(bookId: bookId, interactor: interactor, router: router)
        return BookDetailView(presenter: presenter)
    }
}
