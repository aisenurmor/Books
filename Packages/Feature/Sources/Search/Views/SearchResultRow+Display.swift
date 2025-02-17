//
//  SearchResultRow+Display.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Foundation
import Model

extension SearchResultRow {
    
    struct Display: Identifiable {
        let id: String
        let title: String
        let imageUrl: URL?
        let author: String
        let publishDate: String
        
        init(
            id: String,
            title: String,
            imageUrl: URL?,
            author: String, 
            publishDate: String
        ) {
            self.id = id
            self.title = title
            self.imageUrl = imageUrl
            self.author = author
            self.publishDate = publishDate
        }
        
        init(_ book: Book) {
            self.init(
                id: book.id,
                title: book.title,
                imageUrl: URL(string: book.imageUrl),
                author: book.author,
                publishDate: book.publishDate.formatted()
            )
        }
    }
}
