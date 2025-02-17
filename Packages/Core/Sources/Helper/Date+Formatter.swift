//
//  File.swift
//  
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import Foundation

public extension Date {
    
    var fullDateFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: self)
    }
}
