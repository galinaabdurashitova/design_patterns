//
//  TypeFilterButton.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 01.07.2025.
//

import SwiftUI

struct TypeFilterButton: View {
    @Binding var isTypeFilterSheetPresented: Bool
    @Binding var selectedTypes: [DesignPatternType]
    
    var body: some View {
        Button(action: {
            isTypeFilterSheetPresented = true
        }) {
            HStack(spacing: 4) {
                Image(systemName: "line.3.horizontal.decrease")
                    .fontWeight(selectedTypes.isEmpty ? .light : .medium)
                
                switch selectedTypes.count {
                case 0:
                    Text("Type")
                        .fontWeight(.light)
                        .opacity(0.4)
                case 1:
                    Text(selectedTypes[0].name)
                        .fontWeight(.medium)
                        .fontWidth(.condensed)
                default:
                    Text("\(selectedTypes.count) types")
                        .fontWeight(.medium)
                        .fontWidth(.condensed)
                }
            }
            .foregroundColor(.black)
            .filterFieldStyle(
                cornerRadius: 36,
                lineWidth: selectedTypes.isEmpty ? 0.5 : 2
            )
        }
        .typeFilterSheet(
            isPresented: $isTypeFilterSheetPresented,
            selectedTypes: $selectedTypes
        )
    }
}

#Preview {
    TypeFilterButton(
        isTypeFilterSheetPresented: .constant(false),
        selectedTypes: .constant([])
    )
}
