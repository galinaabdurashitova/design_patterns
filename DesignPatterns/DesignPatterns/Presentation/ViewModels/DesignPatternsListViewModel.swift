//
//  DesignPatternsListViewModel.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 28.05.2025.
//

import Foundation
import Combine

@MainActor
class DesignPatternsListViewModel: ObservableObject {
    @Published var designPatternsState: UIState<[DesignPattern]> = .idle
    @Published var selectedPattern: DesignPattern?
    
    @Published var searchText: String = ""
    @Published var selectedTypes: [DesignPatternType] = []
    
    @Published var isTypeFilterSheetPresented: Bool = false
    
    private let useCase: DesignPatternUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    private let debounceIntervalMs: Int = 600
    
    init(useCase: DesignPatternUseCaseProtocol) {
        self.useCase = useCase
        bindSearch()
    }
    
    private func bindSearch() {
        $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(debounceIntervalMs), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.fetchDesignPatterns()
            }
            .store(in: &cancellables)
        
        $selectedTypes
            .removeDuplicates()
            .debounce(for: .milliseconds(debounceIntervalMs), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.fetchDesignPatterns()
            }
            .store(in: &cancellables)
    }
    
    func fetchDesignPatterns() {
        designPatternsState = .loading
        Task {
            do {
                let patterns = try await useCase.getPatternsFiltered(
                    byName: searchText,
                    byTypes: selectedTypes
                )
                
                designPatternsState = .success(patterns)
            } catch {
                designPatternsState = .error(error)
            }
        }
    }
}
