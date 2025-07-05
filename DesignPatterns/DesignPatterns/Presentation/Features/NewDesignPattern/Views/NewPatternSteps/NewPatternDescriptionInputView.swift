//
//  NewPatternDescriptionInputView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 01.07.2025.
//

import SwiftUI

struct NewPatternDescriptionInputView: View {
    @ObservedObject var viewModel: NewPatternViewModel
    @FocusState var isFocused
    
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
                .focused($isFocused)
                .frame(minHeight: 100, alignment: .topLeading)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray), lineWidth: 1)
                )
            }
            
            buttonsView
        }
    }
    
    private var buttonsView: some View {
        HStack(spacing: 8) {
            MainButtonView(colour: .primary.opacity(0.2)) {
                viewModel.creationStep = viewModel.creationStep.previous
            } content: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.left")
                        .fontWeight(.bold)
                    Text("Back")
                        .font(.system(size: 14, weight: .bold))
                        .fontWidth(.expanded)
                }
            }
            
            MainButtonView(
                isDisabled: Binding(
                    get: { continueButtonDisabled },
                    set: { _ in }
                ),
                action: setToNextStep
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
    
    private func setToNextStep() {
        isFocused = false
        viewModel.nextStep()
    }
}

#Preview {
    NewPatternDescriptionInputView(viewModel: ViewModelFactory.makeNewPatternViewModel())
        .padding()
}
