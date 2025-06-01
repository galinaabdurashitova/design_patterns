//
//  DesignPatternsListView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 28.05.2025.
//

import SwiftUI

struct DesignPatternsListView: View {
    @StateObject var viewModel: DesignPatternsListViewModel = DesignPatternsListViewModel()
    
    var body: some View {
        VStack(spacing: 12) {
            screenHeader
            
            listContentView
        }
        .background { BackgroundGradient() }
        .onAppear(perform: loadScreenData)
        .blur(radius: viewModel.selectedPattern != nil ? 5 : 0)
        .disabled(viewModel.selectedPattern != nil)
        .patternViewOverlay($viewModel.selectedPattern)
    }
    
    private var screenHeader: some View {
        Text(LocalizedStringKey("Design Patterns"))
            .font(.system(size: 32, weight: .bold, design: .rounded))
            .kerning(-1.2)
            .accessibilityIdentifier("designPatternsTitle")
    }

    @ViewBuilder
    private var listContentView: some View {
        switch viewModel.designPatternsState {
        case .idle, .loading:
            ProgressView()
        case .error(let error):
            errorView(error: error)
        case .success(let patterns) where patterns.isEmpty:
            Text("No design patterns found.")
                .opacity(0.6)
        case .success(let patterns):
            listView(patterns: patterns)
        }
    }
    
    private func listView(patterns: [DesignPattern]) -> some View {
        ScrollView {
            LazyVStack(spacing:8) {
                ForEach(Array(patterns.enumerated()), id: \.offset) { index, pattern in
                    patternLine(index: index, pattern: pattern)
                        .accessibilityIdentifier("patternRow_\(index)")
                }
            }
            .padding()
        }
    }
    
    private func patternLine(index: Int, pattern: DesignPattern) -> some View {
        HStack(spacing: 8) {
            Text(String(index+1))
                .font(.system(size: 16, weight: .black, design: .rounded))
            
            Button(action: {
                viewModel.selectedPattern = pattern
            }) {
                HStack(spacing: 12) {
                    Text(pattern.type.emojiIcon)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(pattern.type.color)
                        )
                    
                    Text(pattern.name)
                        .font(.system(size: 18, weight: .light, design: .rounded))
                        .foregroundColor(.black)
                        .kerning(-0.4)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black)
                }
                .padding(8)
                .background(
                    Capsule().fill(Color.white.opacity(0.8))
                )
            }
        }
    }
    
    private func errorView(error: Error) -> some View {
        VStack {
            Text("An error occured loading patterns: \(error.localizedDescription)")
                .opacity(0.6)
                .multilineTextAlignment(.center)
            
            Button(action: viewModel.fetchDesignPatterns) {
                Text("Try again")
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.gray)
                    )
            }
        }
        .padding()
    }
    
    private func loadScreenData() {
        if case .idle = viewModel.designPatternsState {
            viewModel.fetchDesignPatterns()
        }
    }
}

#Preview {
    DesignPatternsListView(viewModel: DesignPatternsListViewModel())
}
