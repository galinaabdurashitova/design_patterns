//
//  MockCodeExampleRepository.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 25.06.2025.
//

import Foundation
@testable import DesignPatterns

class MockCodeExampleRepository: CodeExampleRepositoryProtocol {
    var examples = MockCodeExamples.codeExamples
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
    
    func addCodeExample(_ codeExample: String, for patternId: UUID) throws {
        if throwError { throw TestError.sample }
        let newCodeExample = CodeExample(patternId: patternId, code: codeExample)
        examples.append(newCodeExample)
    }
    
    func updateCodeExample(_ id: UUID, codeExample: String, for patternId: UUID) throws {
        guard let index = examples.firstIndex(where: { $0.id == id }) else {
            throw DataSourceError.notFound
        }
        examples[index].code = codeExample
        examples[index].patternId = patternId
    }
}
