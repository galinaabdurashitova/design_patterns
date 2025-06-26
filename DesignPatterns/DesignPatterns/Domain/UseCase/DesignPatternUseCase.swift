//
//  DesignPatternUseCase.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import Foundation

protocol DesignPatternUseCaseProtocol {
    func getPatterns() async throws -> [DesignPattern]
    func getPatternsFiltered(byName: String, byTypes: [DesignPatternType]) async throws -> [DesignPattern]
    func addPattern(name: String, type: DesignPatternType, description: String, codeExamples: [String]) async throws
}

class DesignPatternUseCase<Filter: FilterProtocol>: DesignPatternUseCaseProtocol where Filter.T == DesignPattern {
    private let designPatternRepository: DesignPatternRepositoryProtocol
    private let codeExampleRepository: CodeExampleRepositoryProtocol
    private let filter: Filter
    
    init(
        repository: DesignPatternRepositoryProtocol = DesignPatternRepository(),
        codeExampleRepository: CodeExampleRepositoryProtocol = CodeExampleRepository(),
        filter: Filter = DesignPatternFilter()
    ) {
        self.designPatternRepository = repository
        self.codeExampleRepository = codeExampleRepository
        self.filter = filter
    }
    
    func getPatterns() async throws -> [DesignPattern] {
        return try await designPatternRepository.getPatterns()
    }
    
    func getPatternsFiltered(byName name: String, byTypes types: [DesignPatternType]) async throws -> [DesignPattern] {
        let patterns = try await designPatternRepository.getPatterns()
        
        if !name.isEmpty, !types.isEmpty {
            let spec = AndSpecification(NameSpecification(name), MultipleTypesSpecification(types))
            return filter.filter(items: patterns, with: spec)
            
        } else if !name.isEmpty {
            return filter.filter(items: patterns, with: NameSpecification(name))
            
        } else if !types.isEmpty {
            return filter.filter(items: patterns, with: MultipleTypesSpecification(types))
            
        } else {
            return patterns
        }
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
}
