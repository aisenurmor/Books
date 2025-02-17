//
//  BookGridItemView+Display.swift
//
//
//  Created by Aise Nur Mor on 16.02.2025.
//

import Foundation
import Model

extension BookGridItemView {
    
    struct Display: Identifiable {
        var id: String
        let imageUrl: URL?
        let title: String
        let isFavorite: Bool
        
        init(_ book: Book) {
            self.init(
                id: book.id,
                imageUrl: book.imageUrl,
                title: book.title,
                isFavorite: book.isFavorite
            )
        }
        
        init(
            id: String,
            imageUrl: String,
            title: String,
            isFavorite: Bool
        ) {
            self.id = id
            self.imageUrl = URL(string: imageUrl)
            self.title = title
            self.isFavorite = isFavorite
        }
    }
}
