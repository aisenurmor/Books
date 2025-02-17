//
//  SearchBuilder.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Navigation
import Repository
import SwiftUI

public enum SearchBuilder {
    
    public static func build(with coordinator: any CoordinatorProtocol) -> some View {
        let entity = SearchEntity()
        let repository = BooksRepository.shared
        let interactor = SearchInteractor(entity: entity, repository: repository)
        let router = SearchRouter(coordinator: coordinator)
        let presenter = SearchPresenter(interactor: interactor, router: router)
        return SearchView(presenter: presenter)
    }
}
