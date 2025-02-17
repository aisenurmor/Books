//
//  SearchResultRow.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Model
import SwiftUI

struct SearchResultRow: View {
    
    private let display: Display
    
    init(display: Display) {
        self.display = display
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(display.title)
                    .font(.headline)
                Text(display.author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                Text(display.publishDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            AsyncImage(url: display.imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

#Preview {
    SearchResultRow(display: .init(
        id: "1",
        title: "Lorem ipsum",
        imageUrl: nil,
        author: "Lorem ipsum",
        publishDate: "20.10.2020"
    ))
}
