//
//  NewDesignPatternNameInputView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 01.07.2025.
//

import SwiftUI

struct NewPatternNameInputView<ViewModel: NewPatternViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @FocusState var isFocused
    
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
                        .focused($isFocused)
                    
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
        }
        .onDisappear {
            isFocused = false
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
}

#Preview {
    NewPatternNameInputView(viewModel: ViewModelFactory.makeNewPatternViewModel())
}
