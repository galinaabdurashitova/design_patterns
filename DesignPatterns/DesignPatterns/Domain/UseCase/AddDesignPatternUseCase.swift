//
//  AddDesignPatternUseCase.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 29.06.2025.
//

import Foundation

protocol AddDesignPatternUseCaseProtocol {
    func addPattern(name: String, type: DesignPatternType, description: String, codeExamples: [String]) async throws
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
    
    func addPattern(name: String, type: DesignPatternType, description: String, codeExamples: [String]) async throws {
        let newPattern = try DesignPattern.builder()
            .setName(name)
            .setType(type)
            .setDescription(description)
            .build()
        
        try await designPatternRepository.addPattern(newPattern)
        
        for example in codeExamples {
            try? await codeExampleRepository.addCodeExample(example, for: newPattern.id)
        }
    }
    
    func checkPatternNameUsed(_ name: String) async throws -> Bool {
        let patterns = try await designPatternRepository.getPatterns()
        return patterns.contains(where: { $0.name.lowercased() == name.lowercased() })
    }
}
