//
//  NewPatternViewModel.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 29.06.2025.
//

import Foundation
import Combine

@MainActor
class NewPatternViewModel: ObservableObject {
    @Published var creationStep: DesignPatternCreationStep = .name
    @Published var patternBuilder: DesignPattern.Builder = .init()
    
    @Published var name: String = ""
    @Published var nameCheckState: UIState<Bool> = .idle
    
    @Published var selectedType: DesignPatternType?
    
    @Published var description: String = ""
    
    private let useCase: AddDesignPatternUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    private let debounceIntervalMs: Int = 600
    
    init(useCase: AddDesignPatternUseCaseProtocol) {
        self.useCase = useCase
        bindNameInput()
    }
    
    func nextStep() {
        switch creationStep {
        case .name:
            patternBuilder = patternBuilder.setName(name)
        case .type:
            guard let selectedType else { return }
            patternBuilder = patternBuilder.setType(selectedType)
        case .description:
            break
        case .codeExamples:
            break
        case .confirm:
            break
        }
        creationStep = creationStep.next
    }
    
    private func bindNameInput() {
        $name
            .removeDuplicates()
            .debounce(for: .milliseconds(debounceIntervalMs), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.checkNameAvailability()
            }
            .store(in: &cancellables)
    }
    
    private func checkNameAvailability() {
        guard !name.isEmpty else {
            nameCheckState = .idle
            return
        }
        
        nameCheckState = .loading
        Task {
            do {
                let nameUsed = try await useCase.checkPatternNameUsed(name)
                nameCheckState = .success(nameUsed)
            } catch {
                nameCheckState = .error(error)
            }
        }
    }
}
