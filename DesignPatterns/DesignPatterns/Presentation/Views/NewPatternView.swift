//
//  NewPatternView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 29.06.2025.
//

import SwiftUI

struct NewPatternView: View {
    @StateObject var viewModel: NewPatternViewModel
    @Binding var isPresented: Bool
    
    private var currentStep: Int {
        DesignPatternCreationStep
            .allCases
            .firstIndex(of: viewModel.creationStep)
        ?? 0
    }
    
    private var progressWidth: Double {
        Double(currentStep)
        / Double(DesignPatternCreationStep.allCases.count - 1)
    }
    
    init(viewModel: NewPatternViewModel, isPresented: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._isPresented = isPresented
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            topBar
            progressSeparatorBar
            contentView
                .padding(.horizontal)
                .padding(.bottom)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Subviews
    private var topBar: some View {
        ZStack(alignment: .leading) {
            Button(action: { isPresented = false }) {
                Image(systemName: "xmark")
                    .foregroundColor(.primary)
            }
            
            Text("Add new design pattern \(currentStep+1)/\(DesignPatternCreationStep.allCases.count)")
                .fontWidth(.expanded)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var progressSeparatorBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(.systemGray6))
                
                Rectangle()
                    .fill(.greenAccent)
                    .frame(width: geometry.size.width * progressWidth)
            }
        }
        .frame(height: 4)
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.creationStep {
        case .name:
            nameInputView
        case .type:
            typeChooseStep
        case .description:
            EmptyView()
        case .codeExamples:
            EmptyView()
        case .confirm:
            EmptyView()
        }
    }
    
    private var nameInputView: some View {
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
    
    private var typeChooseStep: some View {
        VStack(spacing: 60) {
            VStack(spacing: 12) {
                Text("Select a type for the new pattern")
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                
                ForEach(DesignPatternType.allCases, id: \.self) { type in
                    Button(action: {
                        viewModel.selectedType = type
                    }) {
                        HStack {
                            Text(type.name)
                                .foregroundColor(.primary)
                                .fontDesign(.monospaced)
                                .fontWeight(viewModel.selectedType == type ? .heavy : .regular)
                            
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
            }
            
            buttonView
        }
    }
    
    private var buttonView: some View {
        Button(action: viewModel.nextStep) {
            HStack(spacing: 8) {
                Text("Continue")
                    .font(.system(size: 14, weight: .bold))
                    .fontWidth(.expanded)
                Image(systemName: "arrow.right")
                    .fontWeight(.bold)
            }
            .foregroundColor(viewModel.continueButtonDisabled ? Color(.systemGray3) : .primary)
            .padding(.vertical, 16)
            .padding(.horizontal, 100)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.blueAccent)
                    .opacity(viewModel.continueButtonDisabled ? 0.4 : 1)
            )
        }
        .disabled(viewModel.continueButtonDisabled)
    }
}

#Preview {
    NewPatternView(viewModel: ViewModelFactory.makeNewPatternViewModel(), isPresented: .constant(true))
}
