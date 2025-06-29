//
//  AddDesignPatternUseCaseTests.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 29.06.2025.
//

import XCTest
@testable import DesignPatterns

final class AddDesignPatternUseCaseTests: XCTestCase {
    private var mockCodeExampleRepository: MockCodeExampleRepository!
    private var mockDesignPatternRepository: MockDesignPatternRepository!
    private var useCase: AddDesignPatternUseCase!
    
    override func setUp() {
        super.setUp()
        mockCodeExampleRepository = MockCodeExampleRepository()
        mockDesignPatternRepository = MockDesignPatternRepository()
        useCase = AddDesignPatternUseCase(
            repository: mockDesignPatternRepository,
            codeExampleRepository: mockCodeExampleRepository
        )
    }
    
    func test_addPattern_success() async throws {
        try await useCase.addPattern(name: "Test", type: .behavioral, description: "A", codeExamples: ["// Code example"])
        let newPatterns = mockDesignPatternRepository.patterns
        XCTAssertEqual(newPatterns.count, TestDesignPatterns.patterns.count+1)
        
        let newPattern = newPatterns[newPatterns.count-1]
        XCTAssertEqual(newPattern.name, "Test")
        XCTAssertEqual(newPattern.type, .behavioral)
        XCTAssertEqual(newPattern.patternDescription, "A")
        
        XCTAssertEqual(mockCodeExampleRepository.examples.count, 1)
        XCTAssertEqual(mockCodeExampleRepository.examples[0].code, "// Code example")
        XCTAssertEqual(mockCodeExampleRepository.examples[0].patternId, newPattern.id)
    }
    
    func test_addPattern_withBuilderError() async {
        do {
            try await useCase.addPattern(name: "", type: .behavioral, description: "", codeExamples: [])
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is DesignPatternError)
        }
    }
    
    func test_addPattern_withRepositoryError() async {
        mockDesignPatternRepository.throwError = true
        do {
            try await useCase.addPattern(name: "Test", type: .behavioral, description: "", codeExamples: [])
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
    
    func test_checkPatternNameUsed_success() async throws {
        let result1 = try await useCase.checkPatternNameUsed("Builder")
        XCTAssertTrue(result1)
        
        let result2 = try await useCase.checkPatternNameUsed("aaa")
        XCTAssertFalse(result2)
    }
    
    func test_checkPatternNameUsed_withRepositoryError() async throws {
        mockDesignPatternRepository.throwError = true
        do {
            _ = try await useCase.checkPatternNameUsed("Builder")
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
}
