//
//  File.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Combine
import Foundation
import Model
import UICore

final class SearchPresenter: SearchPresenterProtocol {
    
    @Published var selectedCategory: BookCategory? = nil
    @Published var searchText = ""
    
    @Published private(set) var viewState: ViewState<[Book]> = .loading
    @Published private(set) var categories: [BookCategory] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private let interactor: SearchInteractorProtocol
    private let router: SearchRouterProtocol
    
    init(
        interactor: SearchInteractorProtocol,
        router: SearchRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
        
        getCategories()
        setupBindings()
    }
    
    func navigateToDetail(by id: String) {
        router.navigateToDetail(by: id)
    }
    
    func retry() {
        viewState = .loading
        searchBooks(query: searchText, category: selectedCategory)
    }
}

// MARK: - Private Methods
private extension SearchPresenter {
    
    func searchBooks(query: String, category: BookCategory? = nil) {
        Task {
            do {
                let results = try await interactor.searchBooks(query: query, category: category)
                await MainActor.run {
                    viewState = .loaded(results)
                }
            } catch {
                viewState = .error(message: "loadBooksFailedMessage".localized)
            }
        }
    }
    
    func setupBindings() {
        Publishers.CombineLatest($searchText, $selectedCategory)
            .removeDuplicates { (previous, current) in
                previous.0 == current.0 && previous.1?.name == current.1?.name
            }
            .sink { [weak self] (text, category) in
                guard let self else { return }
                self.searchBooks(query: text, category: category)
            }
            .store(in: &cancellables)
        
        $searchText
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] value in
                guard let self else { return }
                if !value.isEmpty && self.selectedCategory?.name != value {
                    self.selectedCategory = nil
                }
            }
            .store(in: &cancellables)
        
        $selectedCategory
            .removeDuplicates()
            .sink { [weak self] value in
                guard let self else { return }
                if self.searchText.isEmpty {
                    self.searchText = value?.name ?? ""
                } else if value != nil && !self.searchText.isEmpty {
                    self.searchText = value?.name ?? ""
                }
            }
            .store(in: &cancellables)
    }
    
    func getCategories() {
        Task {
            do {
                categories = try await interactor.getCategories()
            } catch {
                debugPrint("An error occured when get categories: \(error.localizedDescription)")
            }
        }
    }
}
