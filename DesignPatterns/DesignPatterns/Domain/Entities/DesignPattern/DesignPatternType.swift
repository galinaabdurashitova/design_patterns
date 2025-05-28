//
//  DesignPatternType.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import Foundation

enum DesignPatternType {
    case creational, structural, behavioral
    
    var iconName: String {
        switch self {
        case .creational:
            "plus.square.on.square"
        case .structural:
            "square.grid.3x3.topleft.filled"
        case .behavioral:
            "arrowshape.zigzag.forward"
        }
    }
}
