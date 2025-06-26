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
        mockFilter.filteredResult = [MockTestDesignPatterns.patterns[1]]
        let patterns = try await useCase.getPatternsFiltered(byName: "E", byTypes: [])
        XCTAssertEqual(patterns.count, 1)
        XCTAssertEqual(patterns[0].name, "Builder")
        XCTAssertEqual(
            mockFilter.receivedSpecificationType,
            "NameSpecification"
        )
    }
    
    func test_getPatternsFiltered_withType_success() async throws {
        mockDesignPatternRepository.throwError = false
        mockFilter.filteredResult = [MockTestDesignPatterns.patterns[1]]
        let patterns = try await useCase.getPatternsFiltered(byName: "", byTypes: [.creational])
        XCTAssertEqual(patterns.count, 1)
        XCTAssertEqual(patterns[0].name, "Builder")
        XCTAssertEqual(
            mockFilter.receivedSpecificationType,
            "MultipleTypesSpecification"
        )
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
    
    func test_addPattern_success() async throws {
        mockDesignPatternRepository.throwError = false
        try await useCase.addPattern(name: "Test", type: .behavioral, description: "A", codeExamples: ["// Code example"])
        let newPatterns = try await useCase.getPatterns()
        XCTAssertEqual(newPatterns.count, MockTestDesignPatterns.patterns.count+1)
        
        let newPattern = newPatterns[newPatterns.count-1]
        XCTAssertEqual(newPattern.name, "Test")
        XCTAssertEqual(newPattern.type, .behavioral)
        XCTAssertEqual(newPattern.patternDescription, "A")
        
        XCTAssertEqual(mockCodeExampleRepository.examples.count, 1)
        XCTAssertEqual(mockCodeExampleRepository.examples[0].code, "// Code example")
        XCTAssertEqual(mockCodeExampleRepository.examples[0].patternId, newPattern.id)
    }
    
    func test_addPattern_withBuilderError() async throws {
        mockDesignPatternRepository.throwError = false
        do {
            try await useCase.addPattern(name: "", type: .behavioral, description: "", codeExamples: [])
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is DesignPatternError)
        }
    }
    
    func test_addPattern_withRepositoryError() async throws {
        mockDesignPatternRepository.throwError = true
        do {
            try await useCase.addPattern(name: "Test", type: .behavioral, description: "", codeExamples: [])
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
}
