//
//  MockDesignPatternDataSource.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 26.06.2025.
//

import Foundation
@testable import DesignPatterns

class MockDesignPatternDataSource: DesignPatternDataSourceProtocol {
    var patterns = MockTestDesignPatterns.patterns
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
}
