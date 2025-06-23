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
}


