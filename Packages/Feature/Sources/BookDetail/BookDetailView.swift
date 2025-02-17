//
//  BookDetailView.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Model
import SwiftUI
import UIComponents

struct BookDetailView: View {
    
    @StateObject var presenter: BookDetailPresenter
    
    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    favoriteButton
                }
            }
            .alert("Error", isPresented: Binding(
                get: { presenter.error != nil },
                set: { if !$0 { presenter.error = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                if let error = presenter.error {
                    Text(error.localizedDescription)
                }
            }
    }
}

// MARK: - Private Views
private extension BookDetailView {
    
    @ViewBuilder
    var content: some View {
        switch presenter.viewState {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .loaded(let book):
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    bookImage(url: book.imageUrl)
                        .background(.gray.opacity(0.3))
                    bookDetails(book: book)
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
    
    func bookImage(url: String) -> some View {
        let imageHeight: CGFloat = UIScreen.main.bounds.width*0.8
        
        return AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height: imageHeight)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .frame(height: imageHeight)
            case .failure:
                Image(systemName: "book.closed")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .frame(height: imageHeight)
                    .padding()
            default:
                EmptyView()
            }
        }
    }
    
    func bookDetails(book: Book) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(book.title)
                .font(.title)
                .fontWeight(.bold)
            
            Text(presenter.authorName)
                .font(.title3)
                .foregroundColor(.secondary)
            
            Text(presenter.publishedDate)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
    }
    
   @ViewBuilder
    var favoriteButton: some View {
        if case .loaded(let book) = presenter.viewState {
            Button {
                Task {
                    try? await presenter.toggleFavorite()
                }
            } label: {
                Image(systemName: book.isFavorite ? "star.fill" : "star")
                    .foregroundColor(book.isFavorite ? .yellow : .gray)
            }
        } else {
            Button {} label: {
                Image(systemName: "star")
                    .foregroundColor(.gray)
            }
            .disabled(true)
        }
    }
}
