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
    
    override func setUp() {
        super.setUp()
        mockCoreData = MockCoreDataService()
        
        let mockPattern = DesignPatternEntity(context: mockCoreData.testContext)
        mockPattern.id = patternId
        mockPattern.name = "Test"
        mockPattern.type = DesignPatternType.behavioral.rawValue
        mockPattern.patternDescription = "A"
        
        let mockCodeExample = CodeExampleEntity(context: mockCoreData.testContext)
        mockCodeExample.id = exampleId
        mockCodeExample.code = "// Test"
        mockCodeExample.designPatternRelationship = mockPattern
        
        mockCoreData.fetchResult = [mockCodeExample]
        mockCoreData.fetchOneResult = mockCodeExample
        
        dataSource = CodeExampleCoreDataDataSource(coreData: mockCoreData)
    }
    
    override func tearDown() {
        mockCoreData = nil
        dataSource = nil
        super.tearDown()
    }
    

}
