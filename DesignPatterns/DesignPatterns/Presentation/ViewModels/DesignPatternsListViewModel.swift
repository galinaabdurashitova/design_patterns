//
//  DesignPatternsListViewModel.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 28.05.2025.
//

import Foundation

@MainActor
class DesignPatternsListViewModel: ObservableObject {
    @Published var designPatternsState: UIState<[DesignPattern]> = .idle
    
    private let useCase: DesignPatternUseCaseProtocol
    
    init(useCase: DesignPatternUseCaseProtocol = DesignPatternUseCase()) {
        self.useCase = useCase
    }
    
    func fetchDesignPatterns() {
        designPatternsState = .loading
        Task {
            do {
                let patterns = try await useCase.getPatterns()
                designPatternsState = .success(patterns)
            } catch {
                designPatternsState = .error(error)
            }
        }
    }
}
