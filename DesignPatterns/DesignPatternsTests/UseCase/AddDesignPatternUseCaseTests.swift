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
        let newPattern = DesignPattern(id: UUID(), name: "Test", type: .behavioral, patternDescription: "A")
        try await useCase.addPattern(pattern: newPattern, codeExamples: ["// Code example"])
        let newPatterns = mockDesignPatternRepository.patterns
        XCTAssertEqual(newPatterns.count, TestDesignPatterns.patterns.count+1)
        
        let newPatternAdded = newPatterns[newPatterns.count-1]
        XCTAssertEqual(newPatternAdded.name, "Test")
        XCTAssertEqual(newPatternAdded.type, .behavioral)
        XCTAssertEqual(newPatternAdded.patternDescription, "A")
        
        XCTAssertEqual(mockCodeExampleRepository.examples.count, 1)
        XCTAssertEqual(mockCodeExampleRepository.examples[0].code, "// Code example")
        XCTAssertEqual(mockCodeExampleRepository.examples[0].patternId, newPattern.id)
    }
    
    func test_addPattern_withRepositoryError() async {
        mockDesignPatternRepository.throwError = true
        do {
            let newPattern = DesignPattern(name: "Test", type: .behavioral, patternDescription: "A")
            try await useCase.addPattern(pattern: newPattern, codeExamples: [])
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
