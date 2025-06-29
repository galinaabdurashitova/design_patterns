//
//  DesignPatternUseCaseTests.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 25.06.2025.
//

import XCTest
@testable import DesignPatterns

final class FetchDesignPatternsUseCaseTests: XCTestCase {
    private var mockDesignPatternRepository: MockDesignPatternRepository!
    private var mockFilter: MockFilter!
    private var useCase: FetchDesignPatternsUseCase<MockFilter>!

    override func setUp() {
        super.setUp()
        mockDesignPatternRepository = MockDesignPatternRepository()
        mockFilter = MockFilter()
        useCase = FetchDesignPatternsUseCase(
            repository: mockDesignPatternRepository,
            filter: mockFilter
        )
    }
    
    func test_getPatterns_success() async throws {
        let patterns = try await useCase.getPatterns()
        XCTAssertEqual(patterns.count, TestDesignPatterns.patterns.count)
    }

    func test_getPatterns_throwError() async {
        mockDesignPatternRepository.throwError = true
        do {
            _ = try await useCase.getPatterns()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
    
    func test_getPatternsFiltered_withNameAndType_success() async throws {
        mockFilter.filteredResult = [TestDesignPatterns.patterns[1]]
        let patterns = try await useCase.getPatternsFiltered(byName: "E", byTypes: [.creational])
        XCTAssertEqual(patterns.count, 1)
        XCTAssertEqual(patterns[0].name, "Builder")
        XCTAssertEqual(
            mockFilter.receivedSpecificationType,
            "AndSpecification<DesignPattern, NameSpecification, MultipleTypesSpecification>"
        )
    }
    
    func test_getPatternsFiltered_withName_success() async throws {
        mockFilter.filteredResult = [TestDesignPatterns.patterns[1]]
        let patterns = try await useCase.getPatternsFiltered(byName: "E", byTypes: [])
        XCTAssertEqual(patterns.count, 1)
        XCTAssertEqual(patterns[0].name, "Builder")
        XCTAssertEqual(
            mockFilter.receivedSpecificationType,
            "NameSpecification"
        )
    }
    
    func test_getPatternsFiltered_withType_success() async throws {
        mockFilter.filteredResult = [TestDesignPatterns.patterns[1]]
        let patterns = try await useCase.getPatternsFiltered(byName: "", byTypes: [.creational])
        XCTAssertEqual(patterns.count, 1)
        XCTAssertEqual(patterns[0].name, "Builder")
        XCTAssertEqual(
            mockFilter.receivedSpecificationType,
            "MultipleTypesSpecification"
        )
    }
    
    func test_getPatternsFiltered_throwError() async {
        mockDesignPatternRepository.throwError = true
        do {
            _ = try await useCase.getPatternsFiltered(byName: "", byTypes: [])
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
}
