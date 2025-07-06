//
//  NewPatternView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 29.06.2025.
//

import SwiftUI

struct NewPatternView<ViewModel: NewPatternViewModelProtocol>: View {
    // MARK: - Properties
    @StateObject var viewModel: ViewModel
    @Binding var isPresented: Bool
    let onPatternAdd: () -> Void
    
    // MARK: - Computed Properties
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
    
    private var isMainButtonLoading: Bool {
        if case .loading = viewModel.addPatternState {
            return isLastStep
        } else {
            return false
        }
    }
    
    private var isLastStep: Bool {
        viewModel.creationStep == .confirm
    }
    
    // MARK: - Initializer
    init(
        viewModel: ViewModel,
        isPresented: Binding<Bool>,
        onPatternAdd: @escaping () -> Void
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._isPresented = isPresented
        self.onPatternAdd = onPatternAdd
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            topBar
            progressSeparatorBar
            contentView
                .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeInOut(duration: 0.2), value: viewModel.creationStep)
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
        VStack(spacing: 16) {
            switch viewModel.creationStep {
            case .name:
                NewPatternNameInputView(viewModel: viewModel)
                    .padding(.horizontal)
            case .type:
                NewPatternChooseTypeView(viewModel: viewModel)
                    .padding(.horizontal)
            case .description:
                NewPatternDescriptionInputView(viewModel: viewModel)
                    .padding(.horizontal)
            case .codeExamples:
                NewPatternCodeExamplesView(viewModel: viewModel)
            case .confirm:
                NewPatternConfirmView(viewModel: viewModel)
            }
            
            buttonsView
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var buttonsView: some View {
        HStack(spacing: 8) {
            if viewModel.creationStep != .name {
                MainButtonView(colour: .primary.opacity(0.2), action: viewModel.previousStep) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.left")
                            .fontWeight(.bold)
                        Text("Back")
                            .font(.system(size: 14, weight: .bold))
                            .fontWidth(.expanded)
                    }
                }
            }
            
            MainButtonView(
                isDisabled: Binding(
                    get: { viewModel.continueButtonDisabled },
                    set: { _ in }
                ),
                isLoading: Binding(
                    get: { isMainButtonLoading },
                    set: { _ in }
                ),
                colour: isLastStep ? .greenAccent : .blueAccent,
                action: nextStep
            ) {
                HStack(spacing: 8) {
                    Text(isLastStep ? "Save" : "Continue")
                        .font(.system(size: 14, weight: .bold))
                        .fontWidth(.expanded)
                    Image(systemName: isLastStep ? "checkmark" : "arrow.right")
                        .fontWeight(.bold)
                }
            }
        }
    }
    
    private func nextStep() {
        viewModel.nextStep {
            isPresented = !isLastStep
            onPatternAdd()
        }
    }
}

// MARK: - Preview
#Preview {
    NewPatternView(viewModel: ViewModelFactory.makeNewPatternViewModel(), isPresented: .constant(true)) { }
}
