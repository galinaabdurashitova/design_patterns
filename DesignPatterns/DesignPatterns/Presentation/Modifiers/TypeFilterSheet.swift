//
//  TypeFilterSheet.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 03.06.2025.
//

import SwiftUI

extension View {
    func typeFilterSheet(
        isPresented: Binding<Bool>,
        selectedTypes: Binding<[DesignPatternType]>
    ) -> some View {
        self
            .sheet(isPresented: isPresented) {
                TypeFilterView(
                    isPresented: isPresented,
                    selectedTypes: selectedTypes
                )
                .padding()
                .presentationDetents([.fraction(0.4)])
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.disabled)
                .presentationBackground(.ultraThinMaterial)
            }
    }
}
