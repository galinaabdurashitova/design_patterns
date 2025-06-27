//
//  CodeExampleRepository.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 20.05.2025.
//

import Foundation

protocol CodeExampleRepositoryProtocol {
    func getCodeExample(_ id: UUID) async throws -> CodeExample
    func getCodeExamples(patternId: UUID) async throws -> [CodeExample]
    func addCodeExample(_ codeExample: String, for patternId: UUID) async throws
    func updateCodeExample(_ id: UUID, codeExample: String, for patternId: UUID) async throws
}

class CodeExampleRepository: CodeExampleRepositoryProtocol {
    private let dataSource: CodeExampleDataSourceProtocol
    
    init(dataSource: CodeExampleDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func getCodeExample(_ id: UUID) async throws -> CodeExample {
        return try await dataSource.getCodeExample(id)
    }
    
    func getCodeExamples(patternId: UUID) async throws -> [CodeExample] {
        return try await dataSource.getCodeExamples(patternId: patternId)
    }
    
    func addCodeExample(_ codeExample: String, for patternId: UUID) async throws {
        let codeExample = CodeExample(patternId: patternId, code: codeExample)
        return try await dataSource.addCodeExample(codeExample)
    }
    
    func updateCodeExample(_ id: UUID, codeExample: String, for patternId: UUID) async throws {
        let codeExample = CodeExample(id: id, patternId: patternId, code: codeExample)
        return try await dataSource.updateCodeExample(id, codeExample: codeExample)
    }
}
    
