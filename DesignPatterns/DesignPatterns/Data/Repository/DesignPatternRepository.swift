//
//  DesignPatternRepository.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import Foundation

protocol DesignPatternRepositoryProtocol {
    func getPattern(_ id: UUID) async throws -> DesignPattern
    func getPatterns() async throws -> [DesignPattern]
    func addPattern(_ pattern: DesignPattern) async throws
    func updatePattern(_ id: UUID, pattern: DesignPattern) async throws
}

class DesignPatternRepository: DesignPatternRepositoryProtocol {
    private let dataSource: DesignPatternDataSourceProtocol
    
    init(dataSource: DesignPatternDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func getPattern(_ id: UUID) async throws -> DesignPattern {
        return try await dataSource.getPattern(id)
    }
    
    func getPatterns() async throws -> [DesignPattern] {
        return try await dataSource.getPatterns()
    }
    
    func addPattern(_ pattern: DesignPattern) async throws {
        try await dataSource.addPattern(pattern)
    }
    
    func updatePattern(_ id: UUID, pattern: DesignPattern) async throws {
        try await dataSource.updatePattern(id, pattern: pattern)
    }
}
