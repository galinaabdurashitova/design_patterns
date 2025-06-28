//
//  DesignPatternCoreDataDataSourceTests.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 27.06.2025.
//

import XCTest
@testable import DesignPatterns

final class DesignPatternCoreDataDataSourceTests: XCTestCase {
    private var mockCoreData: MockCoreDataService!
    private var dataSource: DesignPatternCoreDataDataSource!
    
    private let patternId = UUID()
    
    override func setUp() {
        super.setUp()
        mockCoreData = MockCoreDataService()
        
        let mockPattern = DesignPatternEntity(context: mockCoreData.testContext)
        mockPattern.id = patternId
        mockPattern.name = "Test"
        mockPattern.type = DesignPatternType.behavioral.rawValue
        mockPattern.patternDescription = "A"
        mockCoreData.fetchResult = [mockPattern]
        
        dataSource = DesignPatternCoreDataDataSource(coreData: mockCoreData)
    }
    
    override func tearDown() {
        mockCoreData = nil
        dataSource = nil
        super.tearDown()
    }
    
    func test_getPatterns_success() throws {
        let patterns = try dataSource.getPatterns()
        XCTAssertEqual(patterns.count, 1)
        
        let pattern = patterns.first!
        XCTAssertEqual(pattern.id, patternId)
        XCTAssertEqual(pattern.name, "Test")
        XCTAssertEqual(pattern.type, .behavioral)
        XCTAssertEqual(pattern.patternDescription, "A")
    }
    
    func test_getPatterns_whenCoreDataThrowsError_throwsError() {
        mockCoreData.throwError = true
        do {
            _ = try dataSource.getPatterns()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
    
    func test_getPattern_success() throws {
        let pattern = try dataSource.getPattern(patternId)
        XCTAssertEqual(pattern.id, patternId)
        XCTAssertEqual(pattern.name, "Test")
        XCTAssertEqual(pattern.type, .behavioral)
        XCTAssertEqual(pattern.patternDescription, "A")
    }
    
    func test_getPattern_withUnknownId_throwsNotFound() {
        do {
            mockCoreData.fetchResult = [ ]
            _ = try dataSource.getPattern(UUID())
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is DataSourceError)
        }
    }
    
    func test_getPattern_whenCoreDataThrowsError_throwsError() {
        mockCoreData.throwError = true
        do {
            _ = try dataSource.getPattern(patternId)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
    
    func test_addPattern_success() throws {
        let newPattern = DesignPattern(name: "New Test", type: .behavioral, patternDescription: "B")
        try dataSource.addPattern(newPattern)
        
        XCTAssertTrue(mockCoreData.didCallSave)
        XCTAssertEqual(mockCoreData.fetchResult.count, 2)
    }
    
    func test_addPattern_whenCoreDataThrowsError_throwsError() {
        mockCoreData.throwError = true
        do {
            let newPattern = DesignPattern(name: "New Test", type: .behavioral, patternDescription: "B")
            try dataSource.addPattern(newPattern)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
    
    func test_updatePattern_success() throws {
        let newPattern = DesignPattern(name: "New Test", type: .behavioral, patternDescription: "B")
        try dataSource.updatePattern(patternId, pattern: newPattern)
        
        XCTAssertTrue(mockCoreData.didCallSave)
        XCTAssertEqual(mockCoreData.fetchResult.count, 1)
    }
    
    func test_updatePattern_withUnknownId_throwsNotFound() {
        do {
            mockCoreData.fetchResult = [ ]
            let newPattern = DesignPattern(name: "New Test", type: .behavioral, patternDescription: "B")
            try dataSource.updatePattern(UUID(), pattern: newPattern)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is DataSourceError)
        }
    }
    
    func test_updatePattern_whenCoreDataThrowsError_throwsError() {
        mockCoreData.throwError = true
        do {
            let newPattern = DesignPattern(name: "New Test", type: .behavioral, patternDescription: "B")
            try dataSource.updatePattern(patternId, pattern: newPattern)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
}
