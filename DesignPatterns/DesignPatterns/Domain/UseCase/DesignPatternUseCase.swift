//
//  DesignPatternUseCase.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import Foundation

protocol DesignPatternUseCaseProtocol {
    func getPatterns() throws -> [DesignPattern]
    func getPatternsFiltered(byName: String) throws -> [DesignPattern]
    func getPatternsFiltered(byType: DesignPatternType) throws -> [DesignPattern]
    func getPatternsFiltered(byName: String, byType: DesignPatternType) throws -> [DesignPattern]
    func addPattern(name: String, type: DesignPatternType, description: String, codeExamples: [String]) throws
}

class DesignPatternUseCase<Filter: FilterProtocol>: DesignPatternUseCaseProtocol where Filter.T == DesignPattern {
    private let repository: DesignPatternRepositoryProtocol
    private let filter: Filter
    
    init(
        repository: DesignPatternRepositoryProtocol = DesignPatternRepository(),
        filter: Filter = DesignPatternFilter()
    ) {
        self.repository = repository
        self.filter = filter
    }
    
    func getPatterns() throws -> [DesignPattern] {
        return try repository.getPatterns()
    }
    
    func getPatternsFiltered(byName name: String) throws -> [DesignPattern] {
        let patterns = try repository.getPatterns()
        return filter.filter(items: patterns, with: NameSpecification(name))
    }
    
    func getPatternsFiltered(byType type: DesignPatternType) throws -> [DesignPattern] {
        let patterns = try repository.getPatterns()
        return filter.filter(items: patterns, with: TypeSpecification(type))
    }
    
    func getPatternsFiltered(byName name: String, byType type: DesignPatternType) throws -> [DesignPattern] {
        let patterns = try repository.getPatterns()
        let spec = AndSpecification(NameSpecification(name), TypeSpecification(type))
        return filter.filter(items: patterns, with: spec)
    }
    
    func addPattern(name: String, type: DesignPatternType, description: String, codeExamples: [String]) throws {
        var newPatternBuilder = DesignPattern.builder()
            .setName(name)
            .setType(type)
        
        for example in codeExamples {
            newPatternBuilder = newPatternBuilder.addCodeExample(example)
        }
        
        let newPattern = try newPatternBuilder.build()
        
        try repository.addPattern(newPattern)
    }
}
