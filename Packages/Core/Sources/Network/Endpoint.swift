//
//  Endpoint.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

public enum HTTPMethod:String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum Endpoint {
    case feed(count: Int)
    
    var path: String {
        return switch self {
        case .feed(let count):
            "books/top-free/\(count)/books.json"
        }
    }
}
