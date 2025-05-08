//
//  DesignPatternRepository.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import Foundation

protocol DesignPatternRepositoryProtocol {
    func getPatterns() -> [DesignPattern]
    func addPattern(_ pattern: DesignPattern)
}

class DesignPatternRepository: DesignPatternRepositoryProtocol {
    func getPatterns() -> [DesignPattern] {
        return DesignPatternsHardcodeArray.patterns
    }
    
    func addPattern(_ pattern: DesignPattern) {
        DesignPatternsHardcodeArray.patterns.append(pattern)
    }
}
