//
//  HomeState.swift
//  
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Model

struct HomeState {
    var books: [Book]
    var isPaginationLoading: Bool
    var isEndOfList: Bool
    
    static var empty: HomeState {
        HomeState(books: [], isPaginationLoading: false, isEndOfList: false)
    }
}
