//
//  DesignPatternUseCase.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import Foundation

protocol FetchDesignPatternsUseCaseProtocol {
    func getPatterns() async throws -> [DesignPattern]
    func getPatternsFiltered(byName: String, byTypes: [DesignPatternType]) async throws -> [DesignPattern]
    func deletePattern(_ id: UUID) async throws
}

class FetchDesignPatternsUseCase<Filter: FilterProtocol>: FetchDesignPatternsUseCaseProtocol where Filter.T == DesignPattern {
    private let designPatternRepository: DesignPatternRepositoryProtocol
    private let filter: Filter
    
    init(
        repository: DesignPatternRepositoryProtocol,
        filter: Filter = DesignPatternFilter()
    ) {
        self.designPatternRepository = repository
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
    
    func deletePattern(_ id: UUID) async throws {
        try await designPatternRepository.deletePattern(id)
    }
}
