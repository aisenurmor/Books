//
//  HomeState.swift
//  
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Model

public struct HomeState {
    public var books: [Book]
    public var isPaginationLoading: Bool
    public var isEndOfList: Bool
    
    public static var empty: HomeState {
        HomeState(books: [], isPaginationLoading: false, isEndOfList: false)
    }
    
    public init(books: [Book], isPaginationLoading: Bool, isEndOfList: Bool) {
        self.books = books
        self.isPaginationLoading = isPaginationLoading
        self.isEndOfList = isEndOfList
    }
}
