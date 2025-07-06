//
//  NewPatternViewModelTests.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 06.07.2025.
//

import XCTest
@testable import DesignPatterns

@MainActor
final class NewPatternViewModelTests: XCTestCase {
    private var mockUseCase: MockAddDesignPatternUseCase!
    private var viewModel: NewPatternViewModel!

    override func setUp() {
        super.setUp()
        mockUseCase = MockAddDesignPatternUseCase()
        viewModel = NewPatternViewModel(useCase: mockUseCase)
    }
    
    
}
