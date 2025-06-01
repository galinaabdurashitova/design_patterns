//
//  DesignPatternOverlay.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 01.06.2025.
//

import Foundation
import SwiftUI

extension View {
    func patternViewOverlay(_ selectedPattern: Binding<DesignPattern?>) -> some View {
        self
            .modifier(DesignPatternOverlay(selectedPattern: selectedPattern))
    }
}

struct DesignPatternOverlay: ViewModifier {
    @Binding var selectedPattern: DesignPattern?
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if let selectedPattern = selectedPattern {
                    DesignPatternView(selectedPattern: selectedPattern) {
                        self.selectedPattern = nil
                    }
                    .transition(.move(edge: .bottom))
                    .padding()
                }
            }
            .animation(.bouncy(duration: 0.2), value: selectedPattern)
    }
}

#Preview {
    DesignPatternsListView(viewModel: DesignPatternsListViewModel())
}
