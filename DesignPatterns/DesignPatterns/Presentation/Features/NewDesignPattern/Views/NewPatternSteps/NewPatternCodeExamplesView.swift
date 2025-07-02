//
//  NewPatternCodeExamplesView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 02.07.2025.
//

import SwiftUI

struct NewPatternCodeExamplesView: View {
    @ObservedObject var viewModel: NewPatternViewModel
    @FocusState var isFocused

    private var continueButtonDisabled: Bool {
        viewModel.codeExamples.allSatisfy { $0.isEmpty }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 60) {
                VStack(spacing: 12) {
                    Text("Add code examples for your pattern")
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                    
                    ForEach(viewModel.codeExamples.indices, id: \.self) { exampleIndex in
                        SyntaxHighlightTextView(
                            text: Binding(
                                get: { viewModel.codeExamples[exampleIndex] },
                                set: { text in
                                    viewModel.codeExamples[exampleIndex] = text
                                }
                            )
                        )
                        .focused($isFocused)
                        .frame(minHeight: 120, alignment: .topLeading)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .inset(by: 0.5)
                                .stroke(Color(.systemGray), lineWidth: 1)
                        )
                    }
                    
                    Button(action: {
                        viewModel.codeExamples.append("")
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.greenAccent)
                            Text("Add another example")
                                .font(.system(size: 14, weight: .light))
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                        )
                    }
                }
                
                buttonView
            }
        }
    }
    
    private var buttonView: some View {
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
    
    private func setToNextStep() {
        isFocused = false
        viewModel.nextStep()
    }
}

#Preview {
    NewPatternCodeExamplesView(viewModel: ViewModelFactory.makeNewPatternViewModel())
        .padding()
}
