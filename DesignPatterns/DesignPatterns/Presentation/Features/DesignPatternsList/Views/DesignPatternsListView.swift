//
//  DesignPatternsListView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 28.05.2025.
//

import SwiftUI

struct DesignPatternsListView<ViewModel: DesignPatternsListViewModelProtocol>: View {
    // MARK: - Properties
    @StateObject var viewModel: ViewModel
    
    @State private var isNewPatternSheetPresented = false
    
    // MARK: - View
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 12) {
                screenHeader
                
                searchLine
                    .padding(.horizontal)
                
                listContentView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            addNewPatternButton
                .padding()
        }
        .blur(radius: viewModel.isTypeFilterSheetPresented ? 5 : 0)
        .background { BackgroundGradient() }
        .onAppear(perform: loadScreenData)
        .patternViewOverlay($viewModel.selectedPattern)
        .fullScreenCover(
            isPresented: $isNewPatternSheetPresented,
            onDismiss: viewModel.fetchDesignPatterns
        ) {
            NewPatternView(
                viewModel: ViewModelFactory.makeNewPatternViewModel(),
                isPresented: $isNewPatternSheetPresented,
                onPatternAdd: viewModel.fetchDesignPatterns
            )
        }
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
        List(Array(patterns.enumerated()), id: \.offset) { index, pattern in
            patternLine(index: index, pattern: pattern)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.deletePattern(pattern)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .accessibilityIdentifier("patternRow-\(pattern.name)")
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .accessibilityIdentifier("PatternsList")
    }
    
    // MARK: Search
    private var searchLine: some View {
        HStack(spacing: 8) {
            SearchTextField(
                searchText: $viewModel.searchText,
                searchHint: "Search patterns"
            )
            
            TypeFilterButton(
                isTypeFilterSheetPresented: $viewModel.isTypeFilterSheetPresented,
                selectedTypes: $viewModel.selectedTypes
            )
            .accessibilityIdentifier("filterButton")
        }
    }
    
    // MARK: Pattern line
    private func patternLine(index: Int, pattern: DesignPattern) -> some View {
        HStack(spacing: 8) {
            Text(String(index+1))
                .font(.system(size: 16, weight: .black, design: .rounded))
            
            Button(action: {
                viewModel.selectedPattern = pattern
            }) {
                pattern.patternLineView()
            }
        }
    }
    
    private var addNewPatternButton: some View {
        Button(action: { isNewPatternSheetPresented = true }) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .padding(20)
                .background(
                    Circle().fill(.greenAccent)
                )
        }
        .accessibilityIdentifier("addPatternButton")
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
