//
//  SearchView.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Model
import SwiftUI

struct SearchView: View {
    
    @StateObject var presenter: SearchPresenter
    
    var body: some View {
        VStack {
            List {
                Section(header: pickerView())  {
                    ForEach(presenter.searchResults) { book in
                        SearchResultRow(display: .init(book))
                            .onTapGesture { [weak presenter] in
                                presenter?.navigateToDetail(for: book)
                            }
                    }
                }
            }
            .listStyle(.grouped)
            .searchable(text: $presenter.searchText)
        }
    }
}

// MARK: - View Builders
private extension SearchView {
    
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
