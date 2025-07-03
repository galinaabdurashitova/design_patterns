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
                
                buttonView
                    .padding(.top, 48)
            }
            .padding(.horizontal)
        }
    }
    
    private var textFieldsStack: some View {
        VStack(spacing: 8) {
            ForEach(viewModel.codeExamples.indices, id: \.self) { exampleIndex in
                ZStack(alignment: .topTrailing) {
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
                            .stroke(
                                viewModel.codeExamples[exampleIndex].isEmpty
                                ? borderColor
                                : Color(.systemGray),
                                lineWidth: 1
                            )
                    )
                    
                    if viewModel.codeExamples.count > 1 {
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
        Button(action: addOption) {
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
            deleteOption(index: index)
        }) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.red)
                .background(Circle().fill(.background))
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
    
    // MARK: - Functions
    private func addOption() {
        if !viewModel.codeExamples.contains(where: { $0.isEmpty }) {
            viewModel.codeExamples.append("")
        } else {
            shakeAndHighlight()
        }
    }
    
    private func deleteOption(index: Int) {
        if viewModel.codeExamples.count > 1 {
            viewModel.codeExamples.remove(at: index)
        } else {
            viewModel.codeExamples[0] = ""
        }
    }
    
    private func shakeAndHighlight() {
        let times = 3
        
        for i in 0...times {
            print(String(i))
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
        isFocused = false
        viewModel.nextStep()
    }
}

#Preview {
    NewPatternCodeExamplesView(viewModel: ViewModelFactory.makeNewPatternViewModel())
}
