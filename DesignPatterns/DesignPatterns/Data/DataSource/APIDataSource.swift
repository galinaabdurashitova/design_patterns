//
//  APIDataSource.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 12.05.2025.
//

import Foundation

class DesignPatternAPIDataSource: DataSourceProtocol {
    let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func getPattern(_ id: UUID) throws -> DesignPattern {
        throw DataSourceError.notImplemented
    }
    
    func getPatterns() throws -> [DesignPattern] {
        throw DataSourceError.notImplemented
    }
    
    func addPattern(_ pattern: DesignPattern) throws {
        throw DataSourceError.notImplemented
    }
    
    func updatePattern(_ id: UUID, pattern: DesignPattern) throws {
        throw DataSourceError.notImplemented
    }
}
