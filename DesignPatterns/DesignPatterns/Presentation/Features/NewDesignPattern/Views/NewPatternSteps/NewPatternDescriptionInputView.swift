//
//  NewPatternDescriptionInputView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 01.07.2025.
//

import SwiftUI

struct NewPatternDescriptionInputView<ViewModel: NewPatternViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @FocusState var isFocused
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Describe the new pattern")
                .fontWeight(.bold)
                .fontDesign(.rounded)
            
            TextField(
                "Design Pattern Description",
                text: $viewModel.description,
                axis: .vertical
            )
            .focused($isFocused)
            .frame(minHeight: 100, alignment: .topLeading)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray), lineWidth: 1)
            )
        }
        .onDisappear {
            isFocused = false
        }
    }
}

#Preview {
    NewPatternDescriptionInputView(viewModel: ViewModelFactory.makeNewPatternViewModel())
        .padding()
}
