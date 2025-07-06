//
//  MockDesignPatternsListViewModel.swift
//  DesignPatternsSnapshotTests
//
//  Created by Galina Abdurashitova on 29.06.2025.
//

import SwiftUI
@testable import DesignPatterns

class MockDesignPatternsListViewModel: DesignPatternsListViewModelProtocol, ObservableObject {
    @Published var designPatternsState: UIState<[DesignPattern]> = .success(MockDesignPatterns.patterns)
    @Published var selectedPattern: DesignPattern?
    @Published var searchText: String = ""
    @Published var selectedTypes: [DesignPatternType] = []
    @Published var isTypeFilterSheetPresented: Bool = false
    
    @MainActor
    func fetchDesignPatterns() { }
    
    @MainActor
    func deletePattern(_ pattern: DesignPattern) { }
}
