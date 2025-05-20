//
//  CodeExampleMocksDataSource.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 20.05.2025.
//

import Foundation

class CodeExampleMocksDataSource: CodeExampleDataSourceProtocol {
    func getCodeExample(_ id: UUID) throws -> CodeExample {
        guard let codeExample = MockCodeExamples.codeExamples.first(where: { $0.id == id }) else {
            throw DataSourceError.notFound
        }
        return codeExample
    }
    
    func getCodeExamples(patternId: UUID) -> [CodeExample] {
        return MockCodeExamples.codeExamples.filter { $0.patternId == patternId }
    }
    
    func addCodeExample(_ codeExample: CodeExample) throws {
        guard !MockCodeExamples.codeExamples.contains(where: { $0.id == codeExample.id }) else {
            throw DataSourceError.idNotUnique
        }
        MockCodeExamples.codeExamples.append(codeExample)
    }
    
    func updateCodeExample(_ id: UUID, codeExample: CodeExample) throws {
        guard let codeExampleIndex = MockCodeExamples.codeExamples.firstIndex(where: { $0.id == id }) else {
            throw DataSourceError.notFound
        }
        
        MockCodeExamples.codeExamples[codeExampleIndex] = codeExample
    }
}
