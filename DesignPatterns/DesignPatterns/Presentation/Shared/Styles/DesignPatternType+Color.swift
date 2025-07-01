//
//  DesignPatternType+Color.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 01.06.2025.
//

import Foundation
import SwiftUI

extension DesignPatternType {
    private var colorBase: String {
        switch self {
        case .creational:
            "pink"
        case .structural:
            "yellow"
        case .behavioral:
            "blue"
        }
    }
    
    var color: Color {
        return Color("\(colorBase)Accent")
    }
    
    var backgroundColor: Color {
        return Color("\(colorBase)Background")
    }
}
