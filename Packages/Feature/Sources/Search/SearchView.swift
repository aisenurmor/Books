//
//  SearchView.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Model
import SwiftUI
import UIComponents

struct SearchView: View {
    
    @StateObject var presenter: SearchPresenter
    
    var body: some View {
        VStack {
            TextField("searchBookPlaceholder", text: $presenter.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)
            
            List {
                Section(header: pickerView())  {
                    content
                }
            }
            .listStyle(.grouped)
        }
        .navigationTitle("searchTitle".localized)
    }
}

// MARK: - View Builders
private extension SearchView {
    
    @ViewBuilder
    var content: some View {
        switch presenter.viewState {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .loaded(let books):
            ForEach(books) { book in
                SearchResultRow(display: .init(book))
                    .onTapGesture { [weak presenter] in
                        presenter?.navigateToDetail(by: book.id)
                    }
            }
            
        case .error(let message):
            ErrorView(
                message: message,
                retryAction: { [weak presenter] in
                    presenter?.retry()
                }
            )
        }
    }
    
    @ViewBuilder
    func pickerView() -> some View {
        Picker("categoryTitle".localized, selection: $presenter.selectedCategory) {
            Text("allCategoriesTitle".localized)
                .tag(nil as BookCategory?)
            ForEach(presenter.categories) { category in
                Text(category.name)
                    .tag(category as BookCategory?)
            }
        }
        .pickerStyle(.navigationLink)
        .labelsHidden()
        .padding(.vertical, 8)
    }
}
