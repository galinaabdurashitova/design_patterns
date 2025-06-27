//
//  CodeExampleRepositoryTests.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 27.06.2025.
//

import XCTest
@testable import DesignPatterns

final class CodeExampleRepositoryTests: XCTestCase {
    private var mockDataSource: MockCodeExampleDataSource!
    private var repository: CodeExampleRepository!
    
    private var testPattern: DesignPattern!
    private var testCodeExample: CodeExample!
    
    override func setUp() {
        super.setUp()
        mockDataSource = MockCodeExampleDataSource()
        testPattern = TestDesignPatterns.patterns.first!
        testCodeExample = CodeExample(patternId: testPattern.id, code: "// Some Code")
        mockDataSource.examples = [testCodeExample]
        
        repository = CodeExampleRepository(dataSource: mockDataSource)
    }

    func test_getCodeExampleWithId_success() async throws {
        let codeExample = try await repository.getCodeExample(mockDataSource.examples[0].id)
        XCTAssertEqual(codeExample.code, "// Some Code")
        XCTAssertEqual(codeExample.patternId, testPattern.id)
    }
    
    func test_getCodeExampleWithId_withUnknownId_throwsNotFound() async {
        do {
            _ = try await repository.getCodeExample(UUID())
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is DataSourceError)
        }
    }
    
    func test_getCodeExamples_success() async throws {
        let codeExamples = try await repository.getCodeExamples(patternId: testPattern.id)
        XCTAssertEqual(codeExamples.count, 1)
        XCTAssertEqual(codeExamples.first!.code, "// Some Code")
        XCTAssertEqual(codeExamples.first!.patternId, testPattern.id)
    }
    
    func test_getCodeExamples_whenPatternIdNotMatched_empty() async throws {
        let codeExamples = try await repository.getCodeExamples(patternId: UUID())
        XCTAssertEqual(codeExamples.count, 0)
    }
    
    func test_getCodeExamples_whenDataSourceThrowsError_throwsError() async {
        mockDataSource.throwError = true
        do {
            _ = try await repository.getCodeExamples(patternId: UUID())
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
    
    func test_addCodeExample_success() async throws {
        try await repository.addCodeExample("// More code", for: testPattern.id)
        
        let newCodeExamples = try await repository.getCodeExamples(patternId: testPattern.id)
        XCTAssertEqual(newCodeExamples.count, 2)
        
        let newCodeExample = newCodeExamples.last!
        XCTAssertEqual(newCodeExample.code, "// More code")
    }
    
    func test_addCodeExample_whenDataSourceThrowsError_throwsError() async {
        mockDataSource.throwError = true
        do {
            try await repository.addCodeExample("// More code", for: testPattern.id)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
    
    func test_updateCodeExample_success() async throws {
        try await repository.updateCodeExample(
            mockDataSource.examples[0].id,
            codeExample: "// Changed",
            for: testPattern.id
        )
        
        let updatedCodeExamples = try await repository.getCodeExamples(patternId: testPattern.id)
        XCTAssertEqual(updatedCodeExamples.count, 1)
        
        let updatedCodeExample = updatedCodeExamples.first!
        XCTAssertEqual(updatedCodeExample.code, "// Changed")
        XCTAssertEqual(updatedCodeExample.patternId, testPattern.id)
    }
    
    func test_updateCodeExample_withUnknownId_throwsNotFound() async {
        do {
            try await repository.updateCodeExample(
                UUID(),
                codeExample: "// Changed",
                for: testPattern.id
            )
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is DataSourceError)
        }
    }
}
