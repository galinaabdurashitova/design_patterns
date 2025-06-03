//
//  FilterFieldStyle.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 03.06.2025.
//

import Foundation
import SwiftUI

extension View {
    func filterFieldStyle(cornerRadius: CGFloat, lineWidth: CGFloat = 0.5) -> some View {
        self
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.white.opacity(0.8))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.black.opacity(0.2), lineWidth: lineWidth)
            )
    }
}
