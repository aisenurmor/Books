//
//  Environment.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Foundation

public enum Environment {
    
    public static var baseURL: String {
        guard let baseURLString = try? Configuration.value(for: "BASE_URL") as String else {
            fatalError("Base URL not found in configuration")
        }
        return baseURLString
    }
}
