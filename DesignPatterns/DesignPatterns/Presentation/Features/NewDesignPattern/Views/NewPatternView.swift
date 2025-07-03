//
//  NewPatternView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 29.06.2025.
//

import SwiftUI

struct NewPatternView: View {
    // MARK: - Properties
    @StateObject var viewModel: NewPatternViewModel
    @Binding var isPresented: Bool
    
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
            EmptyView()
        }
    }
}

// MARK: - Preview
#Preview {
    NewPatternView(viewModel: ViewModelFactory.makeNewPatternViewModel(), isPresented: .constant(true))
}
