//
//  CodeExampleError.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 24.06.2025.
//

import Foundation

enum CodeExampleError: Error, LocalizedError {
    case emptyId, emptyCode, missingPattern
    
    var errorDescription: String? {
        switch self {
        case .emptyId:
            return "Id cannot be empty"
        case .emptyCode:
            return "Code cannot be empty"
        case .missingPattern:
            return "Pattern is missing"
        }
    }
}
