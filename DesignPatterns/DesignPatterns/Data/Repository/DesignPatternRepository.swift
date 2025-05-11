//
//  DesignPatternRepository.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import Foundation

enum DesignPatternRepositoryError: LocalizedError, Error {
    case notFound
    case idNotUnique
    
    var errorDescription: String? {
        switch self {
        case .notFound: return "Pattern not found"
        case .idNotUnique: return "ID not unique"
        }
    }
}

protocol DesignPatternRepositoryProtocol {
    func getPattern(_ id: UUID) throws -> DesignPattern
    func getPatterns() -> [DesignPattern]
    func addPattern(_ pattern: DesignPattern) throws
    func updatePattern(_ id: UUID, pattern: DesignPattern) throws
}

class DesignPatternRepository: DesignPatternRepositoryProtocol {
    func getPattern(_ id: UUID) throws -> DesignPattern {
        guard let pattern = DesignPatternsHardcodeArray.patterns.first(where: { $0.id == id }) else {
            throw DesignPatternRepositoryError.notFound
        }
        return pattern
    }
    
    func getPatterns() -> [DesignPattern] {
        return DesignPatternsHardcodeArray.patterns
    }
    
    func addPattern(_ pattern: DesignPattern) throws {
        guard !DesignPatternsHardcodeArray.patterns.contains(where: { $0.id == pattern.id }) else {
            throw DesignPatternRepositoryError.idNotUnique
        }
        DesignPatternsHardcodeArray.patterns.append(pattern)
    }
    
    func updatePattern(_ id: UUID, pattern: DesignPattern) throws {
        guard let patternIndex = DesignPatternsHardcodeArray.patterns.firstIndex(where: { $0.id == id }) else {
            throw DesignPatternRepositoryError.notFound
        }
        
        guard !DesignPatternsHardcodeArray.patterns.contains(where: { $0.id == pattern.id }) else {
            throw DesignPatternRepositoryError.idNotUnique
        }
        
        DesignPatternsHardcodeArray.patterns[patternIndex] = pattern
    }
}
