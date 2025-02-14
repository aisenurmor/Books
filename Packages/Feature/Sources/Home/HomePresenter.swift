//
//  HomePresenter.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Combine
import Foundation
import Model

final class HomePresenter: ObservableObject {
    
    @Published private(set) var books: [Book] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private let interactor: HomeInteractorProtocol
    private let router: HomeRouterProtocol
    
    init(
        interactor: HomeInteractorProtocol = HomeInteractor(),
        router: HomeRouterProtocol = HomeRouter()
    ) {
        self.interactor = interactor
        self.router = router
    }
}

extension HomePresenter: HomePresenterProtocol {
    
    func viewDidLoad() {
        // TODO: Add action
    }
    
    func toggleFavorite(for book: Book) {
        // TODO: Add action
    }
}
