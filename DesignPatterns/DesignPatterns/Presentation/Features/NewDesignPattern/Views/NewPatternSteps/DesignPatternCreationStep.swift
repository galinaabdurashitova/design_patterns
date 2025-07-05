//
//  DesignPatternCreationStep.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 29.06.2025.
//

import Foundation

enum DesignPatternCreationStep: CaseIterable {
    case name, type, description, codeExamples, confirm
    
    var next: DesignPatternCreationStep {
        switch self {
        case .name:         DesignPatternCreationStep.type
        case .type:         DesignPatternCreationStep.description
        case .description:  DesignPatternCreationStep.codeExamples
        case .codeExamples: DesignPatternCreationStep.confirm
        case .confirm:      self
        }
    }
    
    var previous: DesignPatternCreationStep {
        switch self {
        case .name:         self
        case .type:         DesignPatternCreationStep.name
        case .description:  DesignPatternCreationStep.type
        case .codeExamples: DesignPatternCreationStep.description
        case .confirm:      DesignPatternCreationStep.codeExamples
        }
    }
}
