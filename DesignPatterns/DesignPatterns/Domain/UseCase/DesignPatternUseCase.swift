//
//  DesignPatternUseCase.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import Foundation

protocol DesignPatternUseCaseProtocol {
    func getPatterns() -> [DesignPattern]
    func getPatternsFiltered(byName: String) -> [DesignPattern]
    func getPatternsFiltered(byType: DesignPatternType) -> [DesignPattern]
    func getPatternsFiltered(byName: String, byType: DesignPatternType) -> [DesignPattern]
    func addPattern(_ pattern: DesignPattern)
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
    
    func getPatterns() -> [DesignPattern] {
        return repository.getPatterns()
    }
    
    func getPatternsFiltered(byName name: String) -> [DesignPattern] {
        let patterns = repository.getPatterns()
        return filter.filter(items: patterns, with: NameSpecification(name))
    }
    
    func getPatternsFiltered(byType type: DesignPatternType) -> [DesignPattern] {
        let patterns = repository.getPatterns()
        return filter.filter(items: patterns, with: TypeSpecification(type))
    }
    
    func getPatternsFiltered(byName name: String, byType type: DesignPatternType) -> [DesignPattern] {
        let patterns = repository.getPatterns()
        let spec = AndSpecification(NameSpecification(name), TypeSpecification(type))
        return filter.filter(items: patterns, with: spec)
    }
    
    func addPattern(_ pattern: DesignPattern) {
        repository.addPattern(pattern)
    }
}
