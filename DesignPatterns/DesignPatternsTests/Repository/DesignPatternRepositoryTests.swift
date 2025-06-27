//
//  DesignPatternRepositoryTests.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 27.06.2025.
//

import XCTest
@testable import DesignPatterns

final class DesignPatternRepositoryTests: XCTestCase {
    private var mockDataSource: MockDesignPatternDataSource!
    private var repository: DesignPatternRepository!

    override func setUp() {
        super.setUp()
        mockDataSource = MockDesignPatternDataSource()
        repository = DesignPatternRepository(dataSource: mockDataSource)
    }

    func test_getPatternWithId_success() async throws {
        let pattern = try await repository.getPattern(TestDesignPatterns.patterns.first!.id)
        XCTAssertEqual(pattern, TestDesignPatterns.patterns.first!)
    }
    
    func test_getPatternWithId_withUnknownId_throwsNotFound() async {
        do {
            _ = try await repository.getPattern(UUID())
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is DataSourceError)
        }
    }
    
    func test_getPatterns_success() async throws {
        let patterns = try await repository.getPatterns()
        XCTAssertEqual(patterns.count, TestDesignPatterns.patterns.count)
    }
    
    func test_getPatterns_whenDataSourceThrowsError_throwsError() async {
        mockDataSource.throwError = true
        do {
            _ = try await repository.getPatterns()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
    
    func test_addPattern_success() async throws {
        let newPatten = DesignPattern(name: "Test", type: .behavioral, patternDescription: "A")
        try await repository.addPattern(newPatten)
        
        let newPatterns = try await repository.getPatterns()
        XCTAssertEqual(newPatterns.count, TestDesignPatterns.patterns.count+1)
        
        let newPattern = newPatterns.last!
        XCTAssertEqual(newPattern.name, "Test")
        XCTAssertEqual(newPattern.type, .behavioral)
        XCTAssertEqual(newPattern.patternDescription, "A")
    }
    
    func test_addPattern_whenDataSourceThrowsError_throwsError() async {
        mockDataSource.throwError = true
        let newPatten = DesignPattern(name: "Test", type: .behavioral, patternDescription: "A")
        do {
            try await repository.addPattern(newPatten)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
    
    func test_updatePattern_success() async throws {
        let newPatten = DesignPattern(name: "Test", type: .behavioral, patternDescription: "A")
        try await repository.updatePattern(TestDesignPatterns.patterns.first!.id, pattern: newPatten)
        
        let updatedPatterns = try await repository.getPatterns()
        XCTAssertEqual(updatedPatterns.count, TestDesignPatterns.patterns.count)
        
        let updatedPattern = updatedPatterns.first!
        XCTAssertEqual(updatedPattern.name, "Test")
        XCTAssertEqual(updatedPattern.type, .behavioral)
        XCTAssertEqual(updatedPattern.patternDescription, "A")
    }
    
    func test_updatePattern_withUnknownId_throwsNotFound() async {
        let newPatten = DesignPattern(name: "Test", type: .behavioral, patternDescription: "A")
        do {
            try await repository.updatePattern(UUID(), pattern: newPatten)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is DataSourceError)
        }
    }
}
