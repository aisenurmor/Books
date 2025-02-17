//
//  BookGridItemView.swift
//
//
//  Created by Aise Nur Mor on 15.02.2025.
//

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
                    .scaledToFill()
                    .frame(height: Constants.imageHeight)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()
            } placeholder: {
                ProgressView()
                    .frame(height: Constants.imageHeight)
            }
            .background(.gray)
            .overlay(alignment: .topTrailing) {
                favoriteButton()
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

// MARK: - Private methods
private extension BookGridItemView {
    
    @ViewBuilder
    func favoriteButton() -> some View {
        Button {
            onFavoriteTapped()
        } label: {
            Image(systemName: display.isFavorite ? "star.fill" : "star")
                .font(.system(size: 12))
                .foregroundColor(display.isFavorite ? .yellow : .blue)
        }
        .frame(
            width: Constants.favoriteButtonHeight,
            height: Constants.favoriteButtonHeight
        )
        .background(.white)
        .cornerRadius(Constants.favoriteButtonHeight/2)
        .padding(8)
    }
}

#Preview {
    BookGridItemView(
        display: .init(
            id: "1",
            imageUrl: "",
            title: "Lorem ipsum",
            isFavorite: true
        )
    ) { }
}
