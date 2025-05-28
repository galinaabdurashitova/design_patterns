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
            Text(LocalizedStringKey("Design Patterns"))
                .font(.title)
                .bold()
                .accessibilityIdentifier("designPatternsTitle")
            
            listContentView
        }
        .onAppear(perform: loadScreenData)
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
            LazyVStack(spacing: 0) {
                ForEach(Array(patterns.enumerated()), id: \.offset) { index, pattern in
                    patternLine(index: index, pattern: pattern)
                        .padding(.vertical, 4)
                        .overlay(
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1),
                            alignment: .bottom
                        )
                        .accessibilityIdentifier("patternRow_\(index)")
                }
            }
            .padding()
        }
    }
    
    private func patternLine(index: Int, pattern: DesignPattern) -> some View {
        HStack {
            Text(String(index+1))
                .padding(8)
                .background(
                    Circle()
                        .fill(.blue.opacity(0.2))
                )
            
            Image(systemName: pattern.type.iconName)
            
            Text(pattern.name)
            
            Spacer()
            
//            Image(systemName: "chevron.right")
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
