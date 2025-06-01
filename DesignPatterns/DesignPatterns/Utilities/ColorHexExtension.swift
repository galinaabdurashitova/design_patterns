//
//  ColorHexExtension.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 01.06.2025.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String, fallback: Color = .clear) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        var hexNumber: UInt64 = 0
        let scanner = Scanner(string: hexString)
        
        guard scanner.scanHexInt64(&hexNumber) else {
            self = fallback
            return
        }

        switch hexString.count {
        case 3: // RGB (12-bit)
            let r = Double((hexNumber >> 8) & 0xF) / 15
            let g = Double((hexNumber >> 4) & 0xF) / 15
            let b = Double(hexNumber & 0xF) / 15
            self.init(red: r, green: g, blue: b)

        case 4: // RGBA (16-bit)
            let r = Double((hexNumber >> 12) & 0xF) / 15
            let g = Double((hexNumber >> 8) & 0xF) / 15
            let b = Double((hexNumber >> 4) & 0xF) / 15
            let a = Double(hexNumber & 0xF) / 15
            self.init(red: r, green: g, blue: b, opacity: a)

        case 6: // RRGGBB (24-bit)
            let r = Double((hexNumber >> 16) & 0xFF) / 255
            let g = Double((hexNumber >> 8) & 0xFF) / 255
            let b = Double(hexNumber & 0xFF) / 255
            self.init(red: r, green: g, blue: b)

        case 8: // RRGGBBAA (32-bit)
            let r = Double((hexNumber >> 24) & 0xFF) / 255
            let g = Double((hexNumber >> 16) & 0xFF) / 255
            let b = Double((hexNumber >> 8) & 0xFF) / 255
            let a = Double(hexNumber & 0xFF) / 255
            self.init(red: r, green: g, blue: b, opacity: a)

        default:
            self = fallback
        }
    }
}
