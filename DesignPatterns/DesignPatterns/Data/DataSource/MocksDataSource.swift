//
//  DesignPatternMocksDataSource.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 12.05.2025.
//

import Foundation

class DesignPatternMocksDataSource: DataSourceProtocol {
    func getPattern(_ id: UUID) throws -> DesignPattern {
        guard let pattern = DesignPatternsHardcodeArray.patterns.first(where: { $0.id == id }) else {
            throw DesignPatternDataSourceError.notFound
        }
        return pattern
    }
    
    func getPatterns() -> [DesignPattern] {
        return DesignPatternsHardcodeArray.patterns
    }
    
    func addPattern(_ pattern: DesignPattern) throws {
        guard !DesignPatternsHardcodeArray.patterns.contains(where: { $0.id == pattern.id }) else {
            throw DesignPatternDataSourceError.idNotUnique
        }
        DesignPatternsHardcodeArray.patterns.append(pattern)
    }
    
    func updatePattern(_ id: UUID, pattern: DesignPattern) throws {
        guard let patternIndex = DesignPatternsHardcodeArray.patterns.firstIndex(where: { $0.id == id }) else {
            throw DesignPatternDataSourceError.notFound
        }
        
        guard !DesignPatternsHardcodeArray.patterns.contains(where: { $0.id == pattern.id }) else {
            throw DesignPatternDataSourceError.idNotUnique
        }
        
        DesignPatternsHardcodeArray.patterns[patternIndex] = pattern
    }
}
