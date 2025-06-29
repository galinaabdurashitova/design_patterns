//
//  MockAddDesignPatternUseCase.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 29.06.2025.
//

import Foundation
@testable import DesignPatterns

class MockAddDesignPatternUseCase: AddDesignPatternUseCaseProtocol {
    var patterns = MockDesignPatterns.patterns
    var throwError: Bool = false
    
    func addPattern(name: String, type: DesignPatternType, description: String, codeExamples: [String]) throws {
        if throwError { throw TestError.sample }
        let newPattern = DesignPattern(name: name, type: type, patternDescription: description)
        patterns.append(newPattern)
    }
    
    func checkPatternNameUsed(_ name: String) throws -> Bool {
        if throwError { throw TestError.sample }
        return patterns.contains(where: { $0.name.lowercased() == name })
    }
}
