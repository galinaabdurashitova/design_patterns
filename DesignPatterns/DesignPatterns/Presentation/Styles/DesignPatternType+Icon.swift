//
//  DesignPatternType+Icon.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 01.06.2025.
//

import Foundation
import SwiftUI

extension DesignPatternType {
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
    
    var emojiIcon: String {
        switch self {
        case .creational:
            "🧱"
        case .structural:
            "🗂️"
        case .behavioral:
            "🧠"
        }
    }
}
