//
//  DesignPatternsListViewModelTests.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 25.06.2025.
//

import XCTest
@testable import DesignPatterns

@MainActor
final class DesignPatternsListViewModelTests: XCTestCase {
    private class MockDesignPatternUseCase: DesignPatternUseCaseProtocol {
        var patterns = MockDesignPatterns.patterns
        var throwError: Bool = false
        
        func getPatterns() throws -> [DesignPattern] {
            if throwError { throw TestError.sample }
            return patterns
        }
        
        func getPatternsFiltered(byName: String, byTypes: [DesignPatternType]) throws -> [DesignPattern] {
            if throwError { throw TestError.sample }
            let filtered = patterns.filter { pattern in
                (byName.isEmpty || pattern.name.contains(byName)) &&
                (byTypes.isEmpty || byTypes.contains(pattern.type))
            }
            return filtered
        }
        
        func addPattern(name: String, type: DesignPatternType, description: String, codeExamples: [String]) throws {
            if throwError { throw TestError.sample }
            let newPattern = DesignPattern(name: name, type: type, patternDescription: description)
            patterns.append(newPattern)
        }
    }
    
    private var mockUseCase: MockDesignPatternUseCase!
    private var viewModel: DesignPatternsListViewModel!

    override func setUp() {
        super.setUp()
        mockUseCase = MockDesignPatternUseCase()
        viewModel = DesignPatternsListViewModel(useCase: mockUseCase)
    }
    
    func test_fetchDesignPatterns_success_setsSuccessState() async {
        viewModel.fetchDesignPatterns()
        try? await Task.sleep(nanoseconds: 200_000_000)
        guard case .success(let patterns) = viewModel.designPatternsState else {
            return XCTFail("Expected success state")
        }
        XCTAssertEqual(patterns.count, mockUseCase.patterns.count)
    }
    
    func test_fetchDesignPatterns_failure_setsErrorState() async {
        mockUseCase.throwError = true
        viewModel.fetchDesignPatterns()
        try? await Task.sleep(nanoseconds: 200_000_000)
        guard case .error(let error) = viewModel.designPatternsState else {
            return XCTFail("Expected error state")
        }
        XCTAssertTrue(error is TestError)
    }
    
    func test_searchTextTriggersFilteredFetch_afterDebounce() async {
        viewModel.searchText = mockUseCase.patterns.first?.name ?? "Some"
        try? await Task.sleep(nanoseconds: 800_000_000)
        guard case .success(let filtered) = viewModel.designPatternsState else {
            return XCTFail("Expected success state after debounce")
        }
        XCTAssertTrue(filtered.allSatisfy { $0.name.contains(viewModel.searchText) })
    }

    func test_selectedTypesTriggersFilteredFetch_afterDebounce() async {
        let typeToSelect = mockUseCase.patterns.first?.type ?? .creational
        viewModel.selectedTypes = [typeToSelect]
        try? await Task.sleep(nanoseconds: 800_000_000)
        guard case .success(let filtered) = viewModel.designPatternsState else {
            return XCTFail("Expected success state after debounce")
        }
        XCTAssertTrue(filtered.allSatisfy { $0.type == typeToSelect })
    }
}
