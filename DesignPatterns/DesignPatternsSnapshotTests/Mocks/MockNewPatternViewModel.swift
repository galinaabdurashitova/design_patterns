//
//  NewPatternViewModelTests.swift
//  DesignPatternsSnapshotTests
//
//  Created by Galina Abdurashitova on 06.07.2025.
//

import XCTest
@testable import DesignPatterns

class MockNewPatternViewModel: NewPatternViewModelProtocol, ObservableObject {
    @Published var creationStep: DesignPatternCreationStep = .name
    @Published var name: String = ""
    @Published var nameCheckState: UIState<Bool> = .idle
    @Published var selectedType: DesignPatternType?
    @Published var description: String = ""
    @Published var codeExamples: [String] = [""]
    @Published var patternBuilder: DesignPattern.Builder = .init()
    @Published var addPatternState: UIState<Bool> = .idle
    
    var continueButtonDisabled: Bool { true }
    
    @MainActor func previousStep() { }
    @MainActor func nextStep(onAddFinished: @escaping () -> Void) { }
    @MainActor func addOption(onAddRestricted: @escaping () -> Void) { }
    @MainActor func deleteOption(index: Int) { }
    @MainActor func addPattern(onAddFinished: @escaping () -> Void) { }
}
