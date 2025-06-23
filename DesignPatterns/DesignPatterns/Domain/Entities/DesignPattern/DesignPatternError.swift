//
//  DesignPatternError.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 11.05.2025.
//

import Foundation

enum DesignPatternError: LocalizedError, Error {
    case emptyName, emptyId, emptyDescrition, invalidType
    
    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Name cannot be empty"
        case .emptyId:
            return "Id cannot be empty"
        case .emptyDescrition:
            return "Description cannot be empty"
        case .invalidType:
            return "Invalid type"
        }
    }
}
