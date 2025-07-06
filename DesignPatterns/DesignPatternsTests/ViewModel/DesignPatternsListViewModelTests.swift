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
    private var mockUseCase: MockFetchDesignPatternsUseCase!
    private var viewModel: DesignPatternsListViewModel!

    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchDesignPatternsUseCase()
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
    
    func test_deletePattern_success_removesFromList() async {
        let patternToDelete = mockUseCase.patterns.first!
        viewModel.fetchDesignPatterns()
        viewModel.deletePattern(patternToDelete)
        try? await Task.sleep(nanoseconds: 200_000_000)
        XCTAssertFalse(mockUseCase.patterns.contains(where: { $0.id == patternToDelete.id }))
    }
    
    func test_deletePattern_withServerError_failure_doesNotRemoveFromList() async {
        mockUseCase.throwError = true
        viewModel.fetchDesignPatterns()
        let patternToDelete = mockUseCase.patterns.first!
        viewModel.deletePattern(patternToDelete)
        try? await Task.sleep(nanoseconds: 200_000_000)
        XCTAssertTrue(mockUseCase.patterns.contains(where: { $0.id == patternToDelete.id }))
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
