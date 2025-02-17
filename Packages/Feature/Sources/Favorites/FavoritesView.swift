//
//  FavoritesView.swift
//  
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Shared
import SwiftUI
import UIComponents

struct FavoritesView: View {
    
    @StateObject var presenter: FavoritesPresenter
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("favoritesTitle".localized)
                .onAppear { [weak presenter] in
                    presenter?.viewDidLoad()
                }
        }
    }
}

// MARK: - View Builders
private extension FavoritesView {
    
    @ViewBuilder
    var content: some View {
        switch presenter.viewState {
        case .loading:
            ProgressView()
            
        case .loaded(let books):
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(books, id: \.id) { book in
                        BookGridItemView(
                            display: .init(book),
                            onFavoriteTapped: { [weak presenter] in
                                presenter?.toggleFavorite(for: book.id)
                            }
                        )
                        .onTapGesture { [weak presenter] in
                            presenter?.navigateToDetail(by: book.id)
                        }
                    }
                }
                .padding()
            }
            
        case .error(let message):
            ErrorView(message: message) {
                //presenter.retry()
            }
        }
    }
}
