//
//  DesignPatternRepository.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import Foundation

protocol DesignPatternRepositoryProtocol {
    func getPattern(_ id: UUID) throws -> DesignPattern
    func getPatterns() throws -> [DesignPattern]
    func addPattern(_ pattern: DesignPattern) throws
    func updatePattern(_ id: UUID, pattern: DesignPattern) throws
}

class DesignPatternRepository: DesignPatternRepositoryProtocol {
    enum AvailableDataSource {
        case mocks
        case api
    }
    
    let dataSource: DataSourceProtocol
    
    init(source: AvailableDataSource = .mocks) {
        self.dataSource = switch source {
        case .api:
            APIDataSourceFactory().makeDataSource()
        case .mocks:
            MocksDataSourceFactory().makeDataSource()
        }
    }
    
    func getPattern(_ id: UUID) throws -> DesignPattern {
        return try dataSource.getPattern(id)
    }
    
    func getPatterns() throws -> [DesignPattern] {
        return try dataSource.getPatterns()
    }
    
    func addPattern(_ pattern: DesignPattern) throws {
        try dataSource.addPattern(pattern)
    }
    
    func updatePattern(_ id: UUID, pattern: DesignPattern) throws {
        try dataSource.updatePattern(id, pattern: pattern)
    }
}
