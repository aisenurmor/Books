//
//  DateFormatter+Extensions.swift
//
//
//  Created by Aise Nur Mor on 16.02.2025.
//

import Foundation

public extension DateFormatter {
    
    static let booksFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
