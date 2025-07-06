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
    // Steps
    @Published var creationStep: DesignPatternCreationStep = .name
    
    // 1. Name step
    @Published var name: String = ""
    @Published var nameCheckState: UIState<Bool> = .idle
    private var cancellables = Set<AnyCancellable>()
    private let debounceIntervalMs: Int = 600
    
    // 2. Type step
    @Published var selectedType: DesignPatternType?
    
    // 3. Description step
    @Published var description: String = ""
    
    // 4. Code examples step
    @Published var codeExamples: [String] = [""]
    
    // New pattern
    @Published var patternBuilder: DesignPattern.Builder = .init()
    @Published var addPatternState: UIState<Bool> = .idle
    
    // Use case
    private let useCase: AddDesignPatternUseCaseProtocol
    
    init(useCase: AddDesignPatternUseCaseProtocol) {
        self.useCase = useCase
        bindNameInput()
    }
    
    // MARK: - Steps logic
    var continueButtonDisabled: Bool {
        switch creationStep {
        case .name:
            switch nameCheckState {
            case .success(let result):
                result || name.isEmpty
            default:
                true
            }
        case .type:
            selectedType == nil
        case .description:
            description.isEmpty
        case .codeExamples:
            codeExamples.allSatisfy { $0.isEmpty }
        case .confirm:
            false
        }
    }
    
    func previousStep() {
        creationStep = creationStep.previous
    }
    
    func nextStep(onAddFinished: @escaping () -> Void) {
        switch creationStep {
        case .name:
            patternBuilder = patternBuilder.setName(name)
        case .type:
            guard let selectedType else { return }
            patternBuilder = patternBuilder.setType(selectedType)
        case .description:
            patternBuilder = patternBuilder.setDescription(description)
        case .codeExamples:
            codeExamples = codeExamples.filter { !$0.isEmpty }
        case .confirm:
            addPattern(onAddFinished: onAddFinished)
        }
        creationStep = creationStep.next
    }
    
    // MARK: - Name validation
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
    
    // MARK: - Code examples methods
    func addOption(onAddRestricted: @escaping () -> Void) {
        if !codeExamples.contains(where: { $0.isEmpty }) {
            codeExamples.append("")
        } else {
            onAddRestricted()
        }
    }
    
    func deleteOption(index: Int) {
        if codeExamples.count > 1 {
            codeExamples.remove(at: index)
        } else {
            codeExamples[0] = ""
        }
    }
    
    // MARK: - Add patern
    func addPattern(onAddFinished: @escaping () -> Void) {
        addPatternState = .loading
        Task {
            do {
                let newPattern = try patternBuilder.build()
                try await useCase.addPattern(pattern: newPattern, codeExamples: codeExamples)
                onAddFinished()
                addPatternState = .success(true)
            } catch {
                addPatternState = .error(error)
            }
        }
    }
}
