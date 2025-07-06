//
//  DesignPatternsListViewModel.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 28.05.2025.
//

import Foundation
import Combine

protocol DesignPatternsListViewModelProtocol: ObservableObject {
    @MainActor var designPatternsState: UIState<[DesignPattern]> { get set }
    @MainActor var selectedPattern: DesignPattern?  { get set }
    @MainActor var searchText: String { get set }
    @MainActor var selectedTypes: [DesignPatternType] { get set }
    @MainActor var isTypeFilterSheetPresented: Bool { get set }
    @MainActor func fetchDesignPatterns()
    @MainActor func deletePattern(_ pattern: DesignPattern)
}

@MainActor
class DesignPatternsListViewModel: DesignPatternsListViewModelProtocol, ObservableObject {
    @Published var designPatternsState: UIState<[DesignPattern]> = .idle
    @Published var selectedPattern: DesignPattern?
    
    @Published var searchText: String = ""
    @Published var selectedTypes: [DesignPatternType] = []
    
    @Published var isTypeFilterSheetPresented: Bool = false
    
    private let useCase: FetchDesignPatternsUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    private let debounceIntervalMs: Int = 600
    
    init(useCase: FetchDesignPatternsUseCaseProtocol) {
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
    
    func deletePattern(_ pattern: DesignPattern) {
        Task {
            do {
                try await useCase.deletePattern(pattern.id)
                fetchDesignPatterns()
            } catch {
                // TODO: add nice error popup
                print(error.localizedDescription)
            }
        }
    }
}
