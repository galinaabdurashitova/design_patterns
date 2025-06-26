//
//  DesignPatternUseCaseTests.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 25.06.2025.
//

import XCTest
@testable import DesignPatterns

final class DesignPatternUseCaseTests: XCTestCase {
    private var mockCodeExampleRepository: MockCodeExampleRepository!
    private var mockDesignPatternRepository: MockDesignPatternRepository!
    private var mockFilter: MockFilter!
    private var useCase: DesignPatternUseCase<MockFilter>!

    override func setUp() {
        super.setUp()
        mockCodeExampleRepository = MockCodeExampleRepository()
        mockDesignPatternRepository = MockDesignPatternRepository()
        mockFilter = MockFilter()
        useCase = DesignPatternUseCase(
            repository: mockDesignPatternRepository,
            codeExampleRepository: mockCodeExampleRepository,
            filter: mockFilter
        )
    }
    
    func test_getPatterns_success() async throws {
        mockDesignPatternRepository.throwError = false
        let patterns = try await useCase.getPatterns()
        XCTAssertEqual(patterns.count, MockTestDesignPatterns.patterns.count)
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
        mockDesignPatternRepository.throwError = false
        mockFilter.filteredResult = [MockTestDesignPatterns.patterns[1]]
        let patterns = try await useCase.getPatternsFiltered(byName: "E", byTypes: [.creational])
        XCTAssertEqual(patterns.count, 1)
        XCTAssertEqual(patterns[0].name, "Builder")
        XCTAssertEqual(
            mockFilter.receivedSpecificationType,
            "AndSpecification<DesignPattern, NameSpecification, MultipleTypesSpecification>"
        )
    }
    
    func test_getPatternsFiltered_withName_success() async throws {
        mockDesignPatternRepository.throwError = false
        #warning("Finish test")
    }
    
    func test_getPatternsFiltered_withType_success() async throws {
        mockDesignPatternRepository.throwError = false
        #warning("Finish test")
    }
    
    func test_getPatternsFiltered_throwError() async throws {
        mockDesignPatternRepository.throwError = true
        do {
            _ = try await useCase.getPatternsFiltered(byName: "", byTypes: [])
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
}
