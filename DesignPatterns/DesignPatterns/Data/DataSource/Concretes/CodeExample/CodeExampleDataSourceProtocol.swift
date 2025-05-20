//
//  CodeExampleDataSourceProtocol.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 20.05.2025.
//

import Foundation

protocol CodeExampleDataSourceProtocol {
    func getCodeExample(_ id: UUID) async throws -> CodeExample
    func getCodeExamples(patternId: UUID) async throws -> [CodeExample]
    func addCodeExample(_ codeExample: CodeExample) async throws
    func updateCodeExample(_ id: UUID, codeExample: CodeExample) async throws
}
