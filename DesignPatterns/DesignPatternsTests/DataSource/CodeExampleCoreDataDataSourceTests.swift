//
//  CodeExampleCoreDataDataSourceTests.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 27.06.2025.
//

import XCTest
@testable import DesignPatterns

final class CodeExampleCoreDataDataSourceTests: XCTestCase {
    private var mockCoreData: MockCoreDataService!
    private var dataSource: CodeExampleCoreDataDataSource!
    
    private let exampleId = UUID()
    private let patternId = UUID()
    
    private var pattern: DesignPatternEntity!
    
    override func setUp() {
        super.setUp()
        mockCoreData = MockCoreDataService()
        
        let mockPattern = DesignPatternEntity(context: mockCoreData.testContext)
        mockPattern.id = patternId
        mockPattern.name = "Test"
        mockPattern.type = DesignPatternType.behavioral.rawValue
        mockPattern.patternDescription = "A"
        pattern = mockPattern
        
        let mockCodeExample = CodeExampleEntity(context: mockCoreData.testContext)
        mockCodeExample.id = exampleId
        mockCodeExample.code = "// Test"
        mockCodeExample.designPatternRelationship = mockPattern
        
        mockCoreData.fetchResult = [mockCodeExample]
        
        dataSource = CodeExampleCoreDataDataSource(coreData: mockCoreData)
    }
    
    override func tearDown() {
        mockCoreData = nil
        dataSource = nil
        super.tearDown()
    }
    
    func test_getCodeExample_success() throws {
        let example = try dataSource.getCodeExample(exampleId)
        XCTAssertEqual(example.id, exampleId)
        XCTAssertEqual(example.code, "// Test")
        XCTAssertEqual(example.patternId, patternId)
    }
    
    func test_getCodeExample_withUnknownId_throwsNotFound() {
        do {
            mockCoreData.fetchResult = []
            _ = try dataSource.getCodeExample(UUID())
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is DataSourceError)
        }
    }
    
    func test_getCodeExample_whenCoreDataThrowsError_throwsError() {
        mockCoreData.throwError = true
        do {
            _ = try dataSource.getCodeExample(exampleId)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
    
    func test_getCodeExamples_success() throws {
        let examples = try dataSource.getCodeExamples(patternId: patternId)
        XCTAssertEqual(examples.count, 1)
        
        let example = examples.first!
        XCTAssertEqual(example.id, exampleId)
        XCTAssertEqual(example.code, "// Test")
        XCTAssertEqual(example.patternId, patternId)
    }
    
    func test_getCodeExamples_withUnknownPatternId_empty() throws {
        mockCoreData.fetchResult = []
        let examples = try dataSource.getCodeExamples(patternId: UUID())
        XCTAssertEqual(examples.count, 0)
    }
    
    func test_getCodeExamples_whenCoreDataThrowsError_throwsError() {
        mockCoreData.throwError = true
        do {
            _ = try dataSource.getCodeExamples(patternId: patternId)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
    
    func test_addExample_success() throws {
        mockCoreData.fetchResult = [ pattern ]
        
        let newExample = CodeExample(patternId: patternId, code: "// Test")
        try dataSource.addCodeExample(newExample)
        
        XCTAssertTrue(mockCoreData.didCallSave)
        XCTAssertEqual(mockCoreData.fetchResult.count, 2)
    }
    
    func test_addExample_withUnknownPatternId_throwsMissingPatternError() throws {
        do {
            let newExample = CodeExample(patternId: UUID(), code: "// Test")
            try dataSource.addCodeExample(newExample)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is CodeExampleError)
        }
    }
    
    func test_addExample_whenCoreDataThrowsError_throwsError() {
        mockCoreData.throwError = true
        do {
            let newExample = CodeExample(patternId: patternId, code: "// Test")
            try dataSource.addCodeExample(newExample)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
    
    func test_updateExample_success() throws {
        mockCoreData.fetchResult.append(pattern)
        let newExample = CodeExample(patternId: patternId, code: "// Test")
        try dataSource.updateCodeExample(exampleId, codeExample: newExample)
        
        XCTAssertTrue(mockCoreData.didCallSave)
        XCTAssertEqual(mockCoreData.fetchResult.count, 2)
    }
    
    func test_updateExample_withUnknownId_throwsNotFound() {
        do {
            mockCoreData.fetchResult = []
            let newExample = CodeExample(patternId: patternId, code: "// Test")
            try dataSource.updateCodeExample(exampleId, codeExample: newExample)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is DataSourceError)
        }
    }
    
    func test_updateExample_withUnknownPatternId_throwsMissingPatternError() {
        do {
            let newExample = CodeExample(patternId: UUID(), code: "// Test")
            try dataSource.updateCodeExample(exampleId, codeExample: newExample)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is CodeExampleError)
        }
    }
    
    func test_updateExample_whenCoreDataThrowsError_throwsError() {
        mockCoreData.throwError = true
        do {
            let newExample = CodeExample(patternId: patternId, code: "// Test")
            try dataSource.updateCodeExample(exampleId, codeExample: newExample)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
}
