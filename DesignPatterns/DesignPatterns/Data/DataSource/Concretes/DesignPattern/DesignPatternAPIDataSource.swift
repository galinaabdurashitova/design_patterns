//
//  APIDataSource.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 12.05.2025.
//

import Foundation

class DesignPatternAPIDataSource: DesignPatternDataSourceProtocol {
    let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func getPattern(_ id: UUID) async throws -> DesignPattern {
        throw DataSourceError.notImplemented
    }
    
    func getPatterns() async throws -> [DesignPattern] {
        throw DataSourceError.notImplemented
    }
    
    func addPattern(_ pattern: DesignPattern) async throws {
        throw DataSourceError.notImplemented
    }
    
    func updatePattern(_ id: UUID, pattern: DesignPattern) async throws {
        throw DataSourceError.notImplemented
    }
}
