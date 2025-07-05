//
//  NewPatternViewModel.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 29.06.2025.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class NewPatternViewModel: ObservableObject {
    @Published var creationStep: DesignPatternCreationStep = .name
    @Published var patternBuilder: DesignPattern.Builder = .init()
    
    @Published var name: String = ""
    @Published var nameCheckState: UIState<Bool> = .idle
    
    @Published var selectedType: DesignPatternType?
    
    @Published var description: String = ""
    @Published var codeExamples: [String] = [""]
    
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
        withAnimation(.easeInOut(duration: 0.2)) { creationStep = creationStep.next }
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
    
    func addOption(onAddRestricted: @escaping () -> Void) {
        if !codeExamples.contains(where: { $0.isEmpty }) {
            codeExamples.append("")
        } else {
            onAddRestricted()
        }
    }
    
    func deleteOption(index: Int) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if codeExamples.count > 1 {
                codeExamples.remove(at: index)
            } else {
                codeExamples[0] = ""
            }
        }
    }
}
