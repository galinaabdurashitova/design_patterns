//
//  DesignPatternType.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import Foundation

enum DesignPatternType: String, CaseIterable {
    case creational = "creational"
    case structural = "structural"
    case behavioral = "behavioral"
    
    var name: String {
        switch self {
        case .creational:
            "Creational"
        case .structural:
            "Structural"
        case .behavioral:
            "Behavioral"
        }
    }
    
    var description: String {
        switch self {
        case .creational:
            "Patterns for making objects without hardcoding the process."
        case .structural:
            "Patterns for organising relationships between objects."
        case .behavioral:
            "Patterns for how objects communicate and work together."
        }
    }
}


