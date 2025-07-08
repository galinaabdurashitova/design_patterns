//
//  NewPatternConfirmView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 06.07.2025.
//

import SwiftUI

struct NewPatternConfirmView<ViewModel: NewPatternViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    
    @State private var isShowingAllCodeExamples: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                Text("Your new design pattern")
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                
                patternContent
                
                if case .error(let error) = viewModel.addPatternState {
                    Text("Couldn't add the pattern: \(error.localizedDescription)")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var patternContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            textField(text: viewModel.name, caption: "Name", vertical: false)
            
            if let type = viewModel.selectedType {
                textField(
                    text: type.emojiIcon + " " + type.name,
                    caption: "Type",
                    colour: type.backgroundColor,
                    vertical: false
                )
            }
            
            textField(text: viewModel.description, caption: "Description")
            
            codeExamplesSection
        }
    }
    
    private var codeExamplesSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Code Examples")
                .font(.system(size: 14, weight: .bold))
            
            let upperBound = isShowingAllCodeExamples ? viewModel.codeExamples.count : min(3, viewModel.codeExamples.count)
            
            ForEach(0..<upperBound, id: \.self) { exampleIndex in
                let example = viewModel.codeExamples[exampleIndex]
                let height = CGFloat(example.count(where: { $0 == "\n" }) * 18 + 18)
                
                SyntaxHighlightTextView(text: example)
                    .frame(height: height)
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .accessibilityIdentifier("addPatternConfirmField-codeExample-\(exampleIndex)")
            }
            
            if viewModel.codeExamples.count > 3 {
                GrayButton {
                    withAnimation { isShowingAllCodeExamples.toggle() }
                } content: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.blueAccent)
                            .rotationEffect(Angle(degrees: isShowingAllCodeExamples ? 180 : 0))
                        Text(isShowingAllCodeExamples ? "Hide all examples" : "Show all examples")
                            .font(.system(size: 14, weight: .light))
                            .foregroundColor(.primary)
                    }
                }
                .accessibilityIdentifier("addPatternConfirmField-codeExamplesExpandButton")
            }
        }
    }
    
    private func textField(
        text: String,
        caption: String,
        colour: Color = Color(.systemGray6),
        vertical: Bool = true
    ) -> some View {
        let layout =
            vertical
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 4))
            : AnyLayout(HStackLayout(alignment: .top, spacing: 8))
        
        return layout {
            Text(caption)
                .font(.system(size: 14, weight: .bold))
            Text(text)
                .monospaced()
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(colour)
                .cornerRadius(8)
                .accessibilityIdentifier("addPatternConfirmField-\(caption)")
        }
    }
}

#Preview {
    NewPatternConfirmView(viewModel: ViewModelFactory.makeNewPatternViewModel())
}
