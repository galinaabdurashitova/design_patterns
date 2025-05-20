//
//  CodeExampleAPIDataSource.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 20.05.2025.
//

import Foundation

class CodeExampleAPIDataSource: CodeExampleDataSourceProtocol {
    let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func getCodeExample(_ id: UUID) async throws -> CodeExample {
        throw DataSourceError.notImplemented
    }
    
    func getCodeExamples(patternId: UUID) async throws -> [CodeExample] {
        throw DataSourceError.notImplemented
    }
    
    func addCodeExample(_ codeExample: CodeExample) async throws {
        throw DataSourceError.notImplemented
    }
    
    func updateCodeExample(_ id: UUID, codeExample: CodeExample) async throws {
        throw DataSourceError.notImplemented
    }
}
    
