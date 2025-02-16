//
//  BookGridItemView.swift
//
//
//  Created by Aise Nur Mor on 15.02.2025.
//

import Model
import SwiftUI

struct BookGridItemView: View {
    typealias FavoriteAction = () -> Void
    
    private enum Constants {
        static let favoriteButtonHeight: CGFloat = 20
        static let imageHeight: CGFloat = 200
    }
    
    private let display: Display
    private let onFavoriteTapped: FavoriteAction
    
    init(
        display: Display,
        onFavoriteTapped: @escaping FavoriteAction
    ) {
        self.display = display
        self.onFavoriteTapped = onFavoriteTapped
    }
    
    var body: some View {
        VStack(spacing: 12) {
            AsyncImage(url: display.imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
                    .frame(maxWidth: .infinity)
            }
            .frame(height: Constants.imageHeight)
            .background(.gray)
            .clipped()
            .overlay(alignment: .topTrailing) {
                Button {
                    onFavoriteTapped()
                } label: {
                    Image(systemName: "star")
                        .font(.system(size: 12))
                }
                .frame(
                    width: Constants.favoriteButtonHeight,
                    height: Constants.favoriteButtonHeight
                )
                .background(.white)
                .cornerRadius(Constants.favoriteButtonHeight/2)
                .padding(8)
            }
            
            Text(display.title)
                .lineLimit(2)
                .font(.caption)
                .padding(.horizontal, 16)
            Spacer()
        }
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

// MARK: - Display
extension BookGridItemView {
    
    struct Display: Identifiable {
        var id: String
        let imageUrl: URL?
        let title: String
        
        init(_ book: Book) {
            self.init(
                id: book.id,
                imageUrl: book.imageUrl,
                title: book.name
            )
        }
        
        init(
            id: String,
            imageUrl: String,
            title: String
        ) {
            self.id = id
            self.imageUrl = URL(string: imageUrl)
            self.title = title
        }
    }
}

#Preview {
    BookGridItemView(display:
        .init(id: "1", imageUrl: "", title: "Lorem ipsum")
    ) { }
}
