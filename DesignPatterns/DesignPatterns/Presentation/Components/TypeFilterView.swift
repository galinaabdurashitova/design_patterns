//
//  TypeFilterView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 03.06.2025.
//

import SwiftUI

struct TypeFilterView: View {
    @Binding var isPresented: Bool
    @Binding var selectedTypes: [DesignPatternType]
    @State private var types: [DesignPatternType] = []
    
    var body: some View {
        VStack(spacing: 16) {
            optionsList
            
            doneButton
        }
        .onAppear {
            types = selectedTypes
        }
    }
    
    private var optionsList: some View {
        VStack(spacing: 8) {
            ForEach(DesignPatternType.allCases, id: \.self) { type in
                typeLine(type)
            }
        }
    }
    
    private func typeLine(_ type: DesignPatternType) -> some View {
        Button(action: {
            selectPatternType(type)
        }) {
            HStack {
                Text(type.emojiIcon)
                    .padding(8)
                    .background(
                        Circle().fill(.white.opacity(0.8))
                    )
                Text(type.name)
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)
                    .fontWidth(.condensed)
                
                Spacer()
                
                patternTypeCheckmarkView(type: type)
            }
            .padding(12)
        }
        .frame(maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(type.backgroundColor.opacity(0.6))
        )
    }
    
    private func patternTypeCheckmarkView(type: DesignPatternType) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.white)
                .frame(width: 32, height: 32)
            
            if types.contains(type) {
                Image(systemName: "checkmark")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
        }
    }
    
    private var doneButton: some View {
        Button(action: {
            selectedTypes = types
            isPresented = false
        }) {
            Text("Done")
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.8))
                )
        }
    }
    
    private func selectPatternType(_ type: DesignPatternType) {
        if types.contains(type) {
            types.removeAll { $0 == type }
        } else {
            types.append(type)
        }
    }
}

#Preview {
    DesignPatternsListView(viewModel: ViewModelFactory.makeDesignPatternsListViewModel())
}
