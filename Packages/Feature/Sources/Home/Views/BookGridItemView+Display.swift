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
        
        init(_ book: Book) {
            self.init(
                id: book.id,
                imageUrl: book.imageUrl,
                title: book.title
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
