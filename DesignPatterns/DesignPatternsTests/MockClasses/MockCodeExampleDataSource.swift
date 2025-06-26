//
//  MockCodeExampleDataSource.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 26.06.2025.
//

import Foundation
@testable import DesignPatterns

class MockCodeExampleDataSource: CodeExampleDataSourceProtocol {
    var examples: [CodeExample] = []
    var throwError: Bool = false
    
    func getCodeExample(_ id: UUID) throws -> CodeExample {
        guard let codeExample = examples.first(where: { $0.id == id }) else {
            throw DataSourceError.notFound
        }
        return codeExample
    }
    
    func getCodeExamples(patternId: UUID) throws -> [CodeExample] {
        if throwError { throw TestError.sample }
        return examples
    }
    
    func addCodeExample(_ codeExample: CodeExample) async throws {
        if throwError { throw TestError.sample }
        examples.append(codeExample)
    }
    
    func updateCodeExample(_ id: UUID, codeExample: CodeExample) async throws {
        guard let index = examples.firstIndex(where: { $0.id == id }) else {
            throw DataSourceError.notFound
        }
        examples[index] = codeExample
    }
}
