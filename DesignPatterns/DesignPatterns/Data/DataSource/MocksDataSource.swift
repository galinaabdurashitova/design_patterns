//
//  DesignPatternMocksDataSource.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 12.05.2025.
//

import Foundation

class DesignPatternMocksDataSource: DataSourceProtocol {
    func getPattern(_ id: UUID) throws -> DesignPattern {
        guard let pattern = MockDesignPatterns.patterns.first(where: { $0.id == id }) else {
            throw DataSourceError.notFound
        }
        return pattern
    }
    
    func getPatterns() -> [DesignPattern] {
        return MockDesignPatterns.patterns
    }
    
    func addPattern(_ pattern: DesignPattern) throws {
        guard !MockDesignPatterns.patterns.contains(where: { $0.id == pattern.id }) else {
            throw DataSourceError.idNotUnique
        }
        MockDesignPatterns.patterns.append(pattern)
    }
    
    func updatePattern(_ id: UUID, pattern: DesignPattern) throws {
        guard let patternIndex = MockDesignPatterns.patterns.firstIndex(where: { $0.id == id }) else {
            throw DataSourceError.notFound
        }
        
        guard !MockDesignPatterns.patterns.contains(where: { $0.id == pattern.id }) else {
            throw DataSourceError.idNotUnique
        }
        
        MockDesignPatterns.patterns[patternIndex] = pattern
    }
}
