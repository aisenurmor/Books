//
//  String+Localizable.swift
//
//
//  Created by Aise Nur Mor on 16.02.2025.
//

import Foundation

public extension String {
    
    var localized: String {
        let localizedKey = String.LocalizationValue(stringLiteral: self)
        return String(localized: localizedKey)
    }
    
    func localized(with arguments: CVarArg...) -> String {
        let format = NSLocalizedString(self, comment: "")
        return String(format: format, arguments: arguments)
    }
}
