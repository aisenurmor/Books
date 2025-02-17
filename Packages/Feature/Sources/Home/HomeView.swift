//
//  HomeView.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Helper
import Model
import Shared
import SwiftUI
import UIComponents

struct HomeView: View {
    
    @StateObject var presenter: HomePresenter
    
    @State private var showingSortOptions = false
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("booksTitle".localized)
                .toolbar {
                    toolbarItems
                }
                .confirmationDialog("sortBooksTitle".localized, isPresented: $showingSortOptions) {
                    sortOptions
                }
                .onAppear { [weak presenter] in
                    presenter?.viewDidLoad()
                }
        }
    }
}

private extension HomeView {
    
    @ViewBuilder
    var content: some View {
        switch presenter.viewState {
        case .loading:
            ProgressView()
            
        case .loaded(let state):
            bookGrid(state: state)
            
        case .error(let message):
            ErrorView(message: message) {
                presenter.retry()
            }
        }
    }
    
    func bookGrid(state: HomeState) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(state.books, id: \.id) { book in
                    BookGridItemView(
                        display: .init(book),
                        onFavoriteTapped: { [weak presenter] in
                            presenter?.toggleFavorite(for: book.id)
                        }
                    )
                    .onAppear { [weak presenter] in
                        presenter?.loadMoreIfNeeded(for: book)
                    }
                    .onTapGesture { [weak presenter] in
                        presenter?.navigateToDetail(by: book.id)
                    }
                }
            }
            .padding()
            
            if state.isPaginationLoading {
                ProgressView()
            }
            
            if state.isEndOfList {
                Text("noMoreBooks".localized)
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }
    
    var toolbarItems: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingSortOptions.toggle()
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .padding(2)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    presenter.navigateToSearch()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .padding(2)
                }
            }
        }
    }
    
    var sortOptions: some View {
        ForEach(SortOption.allCases, id: \.self) { option in
            Button(option.title.localized) {
                presenter.sort(by: option)
            }
        }
    }
}
