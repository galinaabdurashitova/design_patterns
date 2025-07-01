//
//  NewDesignPatternChooseTypeView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 01.07.2025.
//

import SwiftUI

struct NewPatternChooseTypeView: View {
    @ObservedObject var viewModel: NewPatternViewModel
    
    private var continueButtonDisabled: Bool {
        viewModel.selectedType == nil
    }
    
    var body: some View {
        VStack(spacing: 60) {
            VStack(spacing: 12) {
                Text("Select a type for the new pattern")
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                
                ForEach(DesignPatternType.allCases, id: \.self) { type in
                    typeOptionView(type)
                }
            }
            
            buttonView
        }
    }
    
    private func typeOptionView(_ type: DesignPatternType) -> some View {
        Button(action: {
            viewModel.selectedType = type
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(type.name)
                        .foregroundColor(.primary)
                        .fontDesign(.monospaced)
                        .fontWeight(viewModel.selectedType == type ? .heavy : .regular)
                    
                    Text(type.description)
                        .foregroundColor(.primary)
                        .font(.system(size: 14, weight: .light))
                        .opacity(0.6)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                LottieView(
                    animationFileName: "\(type.rawValue)_lottie",
                    loopMode: .loop,
                    isPlaying: Binding<Bool>(
                        get: { viewModel.selectedType == type },
                        set: { _ in }
                    )
                )
                .scaledToFit()
                .frame(height: 80)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        viewModel.selectedType == type
                        ? type.backgroundColor
                        : Color(.systemGray6)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        viewModel.selectedType == type
                        ? type.color
                        : Color(.systemGray4),
                        lineWidth: viewModel.selectedType == type ? 4 : 2
                    )
            )
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
    NewPatternChooseTypeView(viewModel: ViewModelFactory.makeNewPatternViewModel())
}
