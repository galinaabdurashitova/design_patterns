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
    func deletePattern(_ id: UUID) async throws
    func isNameUsed(_ patternName: String) async throws -> Bool
}

class DesignPatternRepository: DesignPatternRepositoryProtocol {
    private let dataSource: DesignPatternDataSourceProtocol
    private var lightCache: [DesignPattern] = []
    
    init(dataSource: DesignPatternDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func getPattern(_ id: UUID) async throws -> DesignPattern {
        return try await dataSource.getPattern(id)
    }
    
    func getPatterns() async throws -> [DesignPattern] {
        let patterns = try await dataSource.getPatterns()
        return patterns
    }
    
    func addPattern(_ pattern: DesignPattern) async throws {
        try await dataSource.addPattern(pattern)
        lightCache = []
    }
    
    func updatePattern(_ id: UUID, pattern: DesignPattern) async throws {
        try await dataSource.updatePattern(id, pattern: pattern)
        lightCache = []
    }
    
    func deletePattern(_ id: UUID) async throws {
        try await dataSource.deletePattern(id)
        lightCache = []
    }
    
    func isNameUsed(_ patternName: String) async throws -> Bool {
        if lightCache.isEmpty {
            lightCache = try await getPatterns()
        }
        return lightCache.contains(where: { $0.name == patternName })
    }
}
