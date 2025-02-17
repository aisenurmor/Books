//
//  HomeView.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Helper
import Model
import SwiftUI

struct HomeView: View {
    
    @StateObject var presenter: HomePresenter
    
    @State private var showingSortOptions = false
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(presenter.books, id: \.id) { book in
                        BookGridItemView(
                            display: .init(book),
                            onFavoriteTapped: { [weak presenter] in
                                presenter?.toggleFavorite(for: book.id)
                        })
                        .onAppear { [weak presenter] in
                            presenter?.loadMoreIfNeeded(for: book)
                        }
                        .onTapGesture { [weak presenter] in
                            presenter?.navigateToDetail(by: book.id)
                        }
                    }
                }
                .padding()
                
                if presenter.isLoading {
                    ProgressView()
                }
            }
            .navigationTitle("booksTitle".localized)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSortOptions.toggle()
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { [weak presenter] in
                        presenter?.navigateToSearch()
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
            .confirmationDialog("sortBooksTitle".localized, isPresented: $showingSortOptions) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button(option.title.localized) { [weak presenter] in
                        presenter?.sort(by: option)
                    }
                }
            }
            .onAppear { [weak presenter] in
                presenter?.viewDidLoad()
            }
        }
    }
}
