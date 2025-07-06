//
//  MockDesignPatternRepository.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 25.06.2025.
//

import Foundation
@testable import DesignPatterns

class MockDesignPatternRepository: DesignPatternRepositoryProtocol {
    var patterns = TestDesignPatterns.patterns
    var throwError: Bool = false
    
    func getPattern(_ id: UUID) throws -> DesignPattern {
        guard let pattern = patterns.first(where: { $0.id == id }) else {
            throw DataSourceError.notFound
        }
        return pattern
    }
    
    func getPatterns() throws -> [DesignPattern] {
        if throwError { throw TestError.sample }
        return patterns
    }
    
    func addPattern(_ pattern: DesignPattern) throws {
        if throwError { throw TestError.sample }
        patterns.append(pattern)
    }
    
    func updatePattern(_ id: UUID, pattern: DesignPattern) throws {
        guard let index = patterns.firstIndex(where: { $0.id == id }) else {
            throw DataSourceError.notFound
        }
        patterns[index] = pattern
    }
    
    func deletePattern(_ id: UUID) throws {
        if throwError { throw TestError.sample }
        patterns.removeAll(where: { $0.id == id })
    }
    
    func isNameUsed(_ patternName: String) throws -> Bool {
        if throwError { throw TestError.sample }
        return patterns.contains(where: { $0.name == patternName })
    }
}
