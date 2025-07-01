//
//  NewDesignPatternNameInputView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 01.07.2025.
//

import SwiftUI

struct NewPatternNameInputView: View {
    @ObservedObject var viewModel: NewPatternViewModel
    
    private var continueButtonDisabled: Bool {
        switch viewModel.nameCheckState {
        case .success(let result):
            result || viewModel.name.isEmpty
        default:
            true
        }
    }
    
    var body: some View {
        VStack(spacing: 60) {
            LottieView(animationFileName: "pattern_lottie", loopMode: .loop)
                .scaledToFit()
                .frame(width: 250)
            
            VStack(spacing: 12) {
                Text("Set a name for the new pattern")
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                
                HStack {
                    TextField("Design Pattern Name", text: $viewModel.name)
                    
                    checkIcon
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray), lineWidth: 1)
                )
                
                if case .error(let error) = viewModel.nameCheckState {
                    Text("Couldn't check the name: \(error.localizedDescription)")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
            }
            
            buttonView
        }
    }
    
    @ViewBuilder
    private var checkIcon: some View {
        switch viewModel.nameCheckState {
        case .idle:
            EmptyView()
        case .loading:
            ProgressView()
        case .error(_):
            Image(systemName: "xmark")
                .foregroundColor(.red)
        case .success(let t):
            Image(systemName: t ? "xmark" : "checkmark")
                .foregroundColor(t ? .red : .green)
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
    NewPatternNameInputView(viewModel: ViewModelFactory.makeNewPatternViewModel())
}
