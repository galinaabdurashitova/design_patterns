//
//  NewPatternCodeExamplesView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 02.07.2025.
//

import SwiftUI

struct NewPatternCodeExamplesView<ViewModel: NewPatternViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @FocusState var focusedField: Int?
    
    @State private var isShaking: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                Text("Add code examples for your pattern")
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                
                textFieldsStack
            }
            .padding(.horizontal)
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.codeExamples)
        .onTapGesture {
            focusedField = nil
        }
        .onDisappear {
            focusedField = nil
        }
    }
    
    private var textFieldsStack: some View {
        VStack(spacing: 8) {
            ForEach(Array(viewModel.codeExamples.enumerated()), id: \.offset) { exampleIndex, example in
                ZStack(alignment: .topTrailing) {
                    SyntaxHighlightTextField(
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
                    .highlightAndShake(
                        isShaking: Binding<Bool>(
                            get: { isShaking && viewModel.codeExamples[exampleIndex].isEmpty },
                            set: { value in isShaking = value }
                        )
                    )
                    .accessibilityIdentifier("addPatternCodeExampleTextField-\(exampleIndex)")
                    
                    if viewModel.codeExamples.count > 1 || !example.isEmpty {
                        deleteOptionButton(index: exampleIndex)
                            .padding([.top, .trailing], -8)
                            .accessibilityIdentifier("addPatternCodeExampleDeleteExample-\(exampleIndex)")
                    }
                }
            }
            
            addCodeExampleButton
        }
    }
    
    private var addCodeExampleButton: some View {
        GrayButton {
            viewModel.addOption(onAddRestricted: { isShaking = true })
        } content: {
            HStack(spacing: 4) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.greenAccent)
                Text("Add another example")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.primary)
            }
        }
        .accessibilityIdentifier("addPatternCodeExampleButton")
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
}


#Preview {
    NewPatternCodeExamplesView(viewModel: ViewModelFactory.makeNewPatternViewModel())
}
