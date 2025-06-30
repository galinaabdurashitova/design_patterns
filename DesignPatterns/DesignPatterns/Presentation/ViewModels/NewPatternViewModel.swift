//
//  NewPatternViewModel.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 29.06.2025.
//

import Foundation
import Combine

class NewPatternViewModel: ObservableObject {
    @Published var creationStep: DesignPatternCreationStep = .type
    @Published var name: String = ""
    @Published var nameCheckState: UIState<Bool> = .idle
    @Published var selectedType: DesignPatternType?
    
    private let useCase: AddDesignPatternUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    private let debounceIntervalMs: Int = 600
    
    var continueButtonDisabled: Bool {
        switch nameCheckState {
        case .success(let result):
            result || name.isEmpty
        default:
            true
        }
    }
    
    init(useCase: AddDesignPatternUseCaseProtocol) {
        self.useCase = useCase
        bindNameInput()
    }
    
    func nextStep() {
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
