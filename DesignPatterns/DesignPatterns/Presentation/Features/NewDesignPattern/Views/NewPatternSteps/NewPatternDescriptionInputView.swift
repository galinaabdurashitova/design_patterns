//
//  NewPatternDescriptionInputView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 01.07.2025.
//

import SwiftUI

struct NewPatternDescriptionInputView: View {
    @ObservedObject var viewModel: NewPatternViewModel
    
    private var continueButtonDisabled: Bool {
        viewModel.description.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 60) {
            VStack(spacing: 12) {
                Text("Describe the new pattern")
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                
                TextField(
                    "Design Pattern Description",
                    text: $viewModel.description,
                    axis: .vertical
                )
                .frame(minHeight: 100, alignment: .topLeading)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray), lineWidth: 1)
                )
            }
            
            buttonView
        }
    }
    
    private var buttonView: some View {
        MainButtonView(
            isDisabled: Binding(
                get: { continueButtonDisabled },
                set: { _ in }
            ),
            action: viewModel.nextStep
        ) {
            HStack(spacing: 8) {
                Text("Continue")
                    .font(.system(size: 14, weight: .bold))
                    .fontWidth(.expanded)
                Image(systemName: "arrow.right")
                    .fontWeight(.bold)
            }
        }
    }
}

#Preview {
    NewPatternDescriptionInputView(viewModel: ViewModelFactory.makeNewPatternViewModel())
        .padding()
}
