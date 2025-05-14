//
//  DesignPatternDataSourceError.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 12.05.2025.
//

import Foundation

enum DataSourceError: LocalizedError, Error {
    case notFound
    case idNotUnique
    case notImplemented
    
    var errorDescription: String? {
        switch self {
        case .notFound: return "Pattern not found"
        case .idNotUnique: return "ID not unique"
        case .notImplemented: return "Not implemented"
        }
    }
}
