//
//  APIDataSource.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 12.05.2025.
//

import Foundation

class DesignPatternAPIDataSource: DataSourceProtocol {
    func getPattern(_ id: UUID) throws -> DesignPattern {
        throw DesignPatternDataSourceError.notImplemented
    }
    
    func getPatterns() throws -> [DesignPattern] {
        throw DesignPatternDataSourceError.notImplemented
    }
    
    func addPattern(_ pattern: DesignPattern) throws {
        throw DesignPatternDataSourceError.notImplemented
    }
    
    func updatePattern(_ id: UUID, pattern: DesignPattern) throws {
        throw DesignPatternDataSourceError.notImplemented
    }
}
