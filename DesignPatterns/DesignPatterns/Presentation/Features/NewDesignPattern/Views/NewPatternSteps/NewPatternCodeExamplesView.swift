//
//  NewPatternCodeExamplesView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 02.07.2025.
//

import SwiftUI

struct NewPatternCodeExamplesView: View {
    @ObservedObject var viewModel: NewPatternViewModel
    @FocusState var focusedField: Int?
        
    @State private var borderColor: Color = Color(.systemGray)
    @State private var shakeOffset: CGFloat = 0

    private var continueButtonDisabled: Bool {
        viewModel.codeExamples.allSatisfy { $0.isEmpty }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                Text("Add code examples for your pattern")
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                
                textFieldsStack
                
                buttonsView
                    .padding(.top, 48)
            }
            .padding(.horizontal)
        }
    }
    
    private var textFieldsStack: some View {
        VStack(spacing: 8) {
            ForEach(Array(viewModel.codeExamples.enumerated()), id: \.offset) { exampleIndex, example in
                ZStack(alignment: .topTrailing) {
                    SyntaxHighlightTextView(
                        text: Binding(
                            get: { viewModel.codeExamples.count > exampleIndex ? viewModel.codeExamples[exampleIndex] : example },
                            set: { text in
                                viewModel.codeExamples[exampleIndex] = text
                            }
                        )
                    )
                    .focused($focusedField, equals: exampleIndex)
                    .frame(minHeight: 120, alignment: .topLeading)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                viewModel.codeExamples[exampleIndex].isEmpty
                                ? borderColor
                                : Color(.systemGray),
                                lineWidth: 1
                            )
                    )
                    
                    if viewModel.codeExamples.count > 1 || !example.isEmpty {
                        deleteOptionButton(index: exampleIndex)
                            .padding([.top, .trailing], -8)
                    }
                }
                .offset(
                    x: viewModel.codeExamples[exampleIndex].isEmpty
                    ? shakeOffset
                    : 0
                )
            }
            
            addCodeExampleButton
        }
    }
    
    private var addCodeExampleButton: some View {
        Button(action: {
            viewModel.addOption(onAddRestricted: shakeAndHighlight)
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
    
    private func deleteOptionButton(index: Int) -> some View {
        Button(action: {
            viewModel.deleteOption(index: index)
        }) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.red)
                .background(Circle().fill(.background))
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
    
    // MARK: - Functions
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
                    default:
                        shakeOffset = 10 * (i % 2 == 0 ? 1 : -1)
                    }
                }
            }
        }
    }
    
    private func setToNextStep() {
        focusedField = nil
        viewModel.nextStep()
    }
}

#Preview {
    NewPatternCodeExamplesView(viewModel: ViewModelFactory.makeNewPatternViewModel())
}
