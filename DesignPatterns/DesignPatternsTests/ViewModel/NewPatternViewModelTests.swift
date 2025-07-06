//
//  NewPatternViewModelTests.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 06.07.2025.
//

import XCTest
import Combine
@testable import DesignPatterns

@MainActor
final class NewPatternViewModelTests: XCTestCase {
    private var mockUseCase: MockAddDesignPatternUseCase!
    private var viewModel: NewPatternViewModel!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        mockUseCase = MockAddDesignPatternUseCase()
        viewModel = NewPatternViewModel(useCase: mockUseCase)
    }
    
    override func tearDown() {
        cancellables.removeAll()
        viewModel = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    func test_nameStep_buttonDisableAndNextStep() async {
        XCTAssertTrue(viewModel.continueButtonDisabled)
        viewModel.name = "Test"
        XCTAssertTrue(viewModel.continueButtonDisabled)
        try? await Task.sleep(for: .seconds(1))
        XCTAssertFalse(viewModel.continueButtonDisabled)
        viewModel.nextStep { }
        XCTAssertEqual(viewModel.creationStep, .type)
    }
    
    func test_typeStep_buttonDisableAndNextStep() {
        viewModel.creationStep = .type
        
        XCTAssertTrue(viewModel.continueButtonDisabled)
        viewModel.nextStep { }
        XCTAssertEqual(viewModel.creationStep, .type)
        
        viewModel.selectedType = .creational
        XCTAssertFalse(viewModel.continueButtonDisabled)
        viewModel.nextStep { }
        XCTAssertEqual(viewModel.creationStep, .description)
    }
    
    func test_descriptionStep_buttonDisableAndNextStep() {
        viewModel.creationStep = .description
        
        XCTAssertTrue(viewModel.continueButtonDisabled)
        
        viewModel.description = "Test"
        XCTAssertFalse(viewModel.continueButtonDisabled)
        viewModel.nextStep { }
        XCTAssertEqual(viewModel.creationStep, .codeExamples)
    }
    
    func test_codeExamplesStep_buttonDisableAndNextStep() {
        viewModel.creationStep = .codeExamples
        
        XCTAssertTrue(viewModel.continueButtonDisabled)
        
        viewModel.codeExamples = ["Test", ""]
        
        viewModel.nextStep { }
        XCTAssertEqual(viewModel.creationStep, .confirm)
        XCTAssertEqual(viewModel.codeExamples.count, 1)
    }
    
    func test_addOption_whenNoEmpty_success() {
        viewModel.codeExamples = ["Test"]
        viewModel.addOption { }
        XCTAssertEqual(viewModel.codeExamples.count, 2)
    }
    
    func test_addOption_whenEmpty_failure() {
        var isCalled = false
        viewModel.addOption { isCalled = true }
        XCTAssertEqual(viewModel.codeExamples.count, 1)
        XCTAssertTrue(isCalled)
    }
    
    func test_deleteOption_whenHasTwoValues_success() {
        viewModel.codeExamples = ["Test1", "Test2"]
        viewModel.deleteOption(index: 1)
        XCTAssertEqual(viewModel.codeExamples.count, 1)
    }
    
    func test_deleteOption_whenHasOneValue_success() {
        viewModel.codeExamples = ["Test1"]
        viewModel.deleteOption(index: 0)
        XCTAssertEqual(viewModel.codeExamples.count, 1)
        XCTAssertEqual(viewModel.codeExamples[0], "")
    }
    
    func test_addPattern_whenValid_success() async {
        viewModel.name = "Test"
        viewModel.nextStep {}
        viewModel.selectedType = .creational
        viewModel.nextStep {}
        viewModel.description = "Test"
        viewModel.nextStep {}
        viewModel.codeExamples = ["Test"]
        viewModel.nextStep {}
        
        var isCalled = false
        viewModel.addPattern { isCalled = true }
        try? await Task.sleep(for: .seconds(1))
        XCTAssertTrue(isCalled)
        guard case .success(_) = viewModel.addPatternState else {
            return XCTFail("Expected success state")
        }
        XCTAssertEqual(mockUseCase.patterns.count, TestDesignPatterns.patterns.count+1)
        let addedPattern = mockUseCase.patterns.last!
        XCTAssertEqual(addedPattern.name, "Test")
        XCTAssertEqual(addedPattern.type, .creational)
        XCTAssertEqual(addedPattern.patternDescription, "Test")
    }
    
    func test_addPattern_whenBuilderError_failure() async {
        var isCalled = false
        viewModel.addPattern { isCalled = true }
        try? await Task.sleep(for: .seconds(1))
        XCTAssertFalse(isCalled)
        guard case .error(let error) = viewModel.addPatternState else {
            return XCTFail("Expected error")
        }
        XCTAssertTrue(error is DesignPatternError)
        XCTAssertEqual(mockUseCase.patterns.count, TestDesignPatterns.patterns.count)
    }
    
    func test_addPattern_whenUseCaseError_failure() async {
        viewModel.name = "Test"
        viewModel.nextStep {}
        
        mockUseCase.throwError = true
        var isCalled = false
        viewModel.addPattern { isCalled = true }
        try? await Task.sleep(for: .seconds(1))
        XCTAssertFalse(isCalled)
        guard case .error(let error) = viewModel.addPatternState else {
            return XCTFail("Expected error")
        }
        XCTAssertTrue(error is TestError)
        XCTAssertEqual(mockUseCase.patterns.count, TestDesignPatterns.patterns.count)
    }
}
