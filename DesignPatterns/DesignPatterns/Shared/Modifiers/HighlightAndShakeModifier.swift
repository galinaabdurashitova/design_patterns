//
//  HighlightAndShakeModifier.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 06.07.2025.
//

import SwiftUI

extension View {
    func highlightAndShake(isShaking: Binding<Bool>) -> some View {
        self.modifier(HighlightAndShakeModifier(isShaking: isShaking))
    }
}

struct HighlightAndShakeModifier: ViewModifier {
    @Binding var isShaking: Bool
    @State private var borderColor: Color = Color(.systemGray)
    @State private var shakeOffset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor)
            )
            .offset(x: shakeOffset)
            .onChange(of: isShaking) { _, newValue in
                if newValue {
                    shakeAndHighlight()
                }
            }
    }
    
    private func shakeAndHighlight() {
        let times = 3
        
        for i in 0...times {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)*0.1) {
                withAnimation(.default) {
                    switch i {
                    case 0:
                        borderColor = .red
                        shakeOffset = 10
                    case times:
                        shakeOffset = 0
                        borderColor = Color(.systemGray)
                        isShaking = false
                    default:
                        shakeOffset = 10 * (i % 2 == 0 ? 1 : -1)
                    }
                }
            }
        }
    }
}
