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
    
    func addPattern(pattern: DesignPattern, codeExamples: [String]) throws {
        if throwError { throw TestError.sample }
        patterns.append(pattern)
    }
    
    func checkPatternNameUsed(_ name: String) throws -> Bool {
        if throwError { throw TestError.sample }
        return patterns.contains(where: { $0.name.lowercased() == name })
    }
}
