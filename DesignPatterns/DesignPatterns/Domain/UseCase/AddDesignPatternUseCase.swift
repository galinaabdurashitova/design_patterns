//
//  AddDesignPatternUseCase.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 29.06.2025.
//

import Foundation

protocol AddDesignPatternUseCaseProtocol {
    func addPattern(pattern: DesignPattern, codeExamples: [String]) async throws
    func checkPatternNameUsed(_ name: String) async throws -> Bool
}

class AddDesignPatternUseCase: AddDesignPatternUseCaseProtocol {
    private let designPatternRepository: DesignPatternRepositoryProtocol
    private let codeExampleRepository: CodeExampleRepositoryProtocol
    
    init(
        repository: DesignPatternRepositoryProtocol,
        codeExampleRepository: CodeExampleRepositoryProtocol
    ) {
        self.designPatternRepository = repository
        self.codeExampleRepository = codeExampleRepository
    }
    
    func addPattern(pattern: DesignPattern, codeExamples: [String]) async throws {
        try await designPatternRepository.addPattern(pattern)
        
        for example in codeExamples where !example.isEmpty {
            try? await codeExampleRepository.addCodeExample(example, for: pattern.id)
        }
    }
    
    func checkPatternNameUsed(_ name: String) async throws -> Bool {
        return try await designPatternRepository.isNameUsed(name)
    }
}
