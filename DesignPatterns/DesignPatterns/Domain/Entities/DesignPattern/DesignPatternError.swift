//
//  DesignPatternError.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 11.05.2025.
//

import Foundation

enum DesignPatternError: LocalizedError, Error {
    case emptyName
    
    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Name cannot be empty"
        }
    }
}
