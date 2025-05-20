//
//  DesignPatternUseCase.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import Foundation

protocol DesignPatternUseCaseProtocol {
    func getPatterns() async throws -> [DesignPattern]
    func getPatternsFiltered(byName: String) async throws -> [DesignPattern]
    func getPatternsFiltered(byType: DesignPatternType) async throws -> [DesignPattern]
    func getPatternsFiltered(byName: String, byType: DesignPatternType) async throws -> [DesignPattern]
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
    
    func getPatternsFiltered(byName name: String) async throws -> [DesignPattern] {
        let patterns = try await designPatternRepository.getPatterns()
        return filter.filter(items: patterns, with: NameSpecification(name))
    }
    
    func getPatternsFiltered(byType type: DesignPatternType) async throws -> [DesignPattern] {
        let patterns = try await designPatternRepository.getPatterns()
        return filter.filter(items: patterns, with: TypeSpecification(type))
    }
    
    func getPatternsFiltered(byName name: String, byType type: DesignPatternType) async throws -> [DesignPattern] {
        let patterns = try await designPatternRepository.getPatterns()
        let spec = AndSpecification(NameSpecification(name), TypeSpecification(type))
        return filter.filter(items: patterns, with: spec)
    }
    
    func addPattern(name: String, type: DesignPatternType, description: String, codeExamples: [String]) async throws {
        let newPattern = try DesignPattern.builder()
            .setName(name)
            .setType(type)
            .build()
        
        try await designPatternRepository.addPattern(newPattern)
        
        for example in codeExamples {
            try? await codeExampleRepository.addCodeExample(example, for: newPattern.id)
        }
    }
}
