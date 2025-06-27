//
//  DesignPatternsListView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 28.05.2025.
//

import SwiftUI

struct DesignPatternsListView: View {
    // MARK: - Properties
    @StateObject var viewModel: DesignPatternsListViewModel
    
    // MARK: - View
    var body: some View {
        VStack(spacing: 12) {
            screenHeader
            
            searchLine
                .padding(.horizontal)
                
            listContentView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .blur(radius: viewModel.isTypeFilterSheetPresented ? 5 : 0)
        .background { BackgroundGradient() }
        .onAppear(perform: loadScreenData)
        .patternViewOverlay($viewModel.selectedPattern)
    }
    
    // MARK: - Sub Views
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
            ErrorView(
                errorDescription: "An error occured loading patterns: \(error.localizedDescription)",
                reloaadAction: viewModel.fetchDesignPatterns
            )
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
            .padding(.horizontal)
        }
    }
    
    // MARK: Search
    private var searchLine: some View {
        HStack(spacing: 8) {
            SearchTextField(
                searchText: $viewModel.searchText,
                searchHint: "Search patterns"
            )
            
            typeFilterButton
        }
    }
    
    private var typeFilterButton: some View {
        Button(action: {
            viewModel.isTypeFilterSheetPresented = true
        }) {
            HStack(spacing: 4) {
                Image(systemName: "line.3.horizontal.decrease")
                    .fontWeight(viewModel.selectedTypes.isEmpty ? .light : .medium)
                
                switch viewModel.selectedTypes.count {
                case 0:
                    Text("Type")
                        .fontWeight(.light)
                        .opacity(0.4)
                case 1:
                    Text(viewModel.selectedTypes[0].name)
                        .fontWeight(.medium)
                        .fontWidth(.condensed)
                default:
                    Text("\(viewModel.selectedTypes.count) types")
                        .fontWeight(.medium)
                        .fontWidth(.condensed)
                }
            }
            .foregroundColor(.black)
            .filterFieldStyle(
                cornerRadius: 36,
                lineWidth: viewModel.selectedTypes.isEmpty ? 0.5 : 2
            )
        }
        .typeFilterSheet(
            isPresented: $viewModel.isTypeFilterSheetPresented,
            selectedTypes: $viewModel.selectedTypes
        )
    }
    
    // MARK: Pattern line
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
    
    // MARK: - Methods
    private func loadScreenData() {
        if case .idle = viewModel.designPatternsState {
            viewModel.fetchDesignPatterns()
        }
    }
}

// MARK: - Preview
#Preview {
    DesignPatternsListView(viewModel: ViewModelFactory.makeDesignPatternsListViewModel())
}
