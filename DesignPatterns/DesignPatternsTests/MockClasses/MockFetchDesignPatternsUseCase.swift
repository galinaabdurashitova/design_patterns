//
//  MockDesignPatternUseCase.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 29.06.2025.
//

@testable import DesignPatterns

class MockFetchDesignPatternsUseCase: FetchDesignPatternsUseCaseProtocol {
    var patterns = MockDesignPatterns.patterns
    var throwError: Bool = false
    
    func getPatterns() throws -> [DesignPattern] {
        if throwError { throw TestError.sample }
        return patterns
    }
    
    func getPatternsFiltered(byName: String, byTypes: [DesignPatternType]) throws -> [DesignPattern] {
        if throwError { throw TestError.sample }
        let filtered = patterns.filter { pattern in
            (byName.isEmpty || pattern.name.contains(byName)) &&
            (byTypes.isEmpty || byTypes.contains(pattern.type))
        }
        return filtered
    }
    
    func addPattern(name: String, type: DesignPatternType, description: String, codeExamples: [String]) throws {
        if throwError { throw TestError.sample }
        let newPattern = DesignPattern(name: name, type: type, patternDescription: description)
        patterns.append(newPattern)
    }
}
