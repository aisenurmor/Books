//
//  ViewState.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

public enum ViewState<T> {
    case loading
    case loaded(T)
    case error(message: String)
}
