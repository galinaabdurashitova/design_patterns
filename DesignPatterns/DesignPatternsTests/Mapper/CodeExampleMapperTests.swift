//
//  CodeExampleMapperTests.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 28.06.2025.
//

import XCTest
@testable import DesignPatterns

final class CodeExampleMapperTests: XCTestCase {
    private var mockCoreData: MockCoreDataService!
    
    override func setUp() {
        super.setUp()
        mockCoreData = MockCoreDataService()
    }
    
    private func buildPatternEntity(id: UUID = UUID()) -> DesignPatternEntity {
        let mockPattern = DesignPatternEntity(context: mockCoreData.testContext)
        mockPattern.id = id
        mockPattern.name = "Test"
        mockPattern.type = DesignPatternType.behavioral.rawValue
        mockPattern.patternDescription = "A"
        return mockPattern
    }
    
    private func buildEntity(
        id: UUID? = UUID(),
        code: String? = "// Test",
        pattern: DesignPatternEntity?
    ) -> CodeExampleEntity {
        let mockCodeExample = CodeExampleEntity(context: mockCoreData.testContext)
        mockCodeExample.id = id
        mockCodeExample.code = code
        mockCodeExample.designPatternRelationship = pattern
        return mockCodeExample
    }
    
    func test_mapFromEntity_whenValidInput_success() throws {
        let pattern = buildPatternEntity()
        let codeExampleEntity = buildEntity(pattern: pattern)
        
        let codeExample = try CodeExampleMapper.from(entity: codeExampleEntity)
        
        XCTAssertEqual(codeExample.id, codeExampleEntity.id)
        XCTAssertEqual(codeExample.code, codeExampleEntity.code)
        XCTAssertEqual(codeExample.patternId, codeExampleEntity.designPatternRelationship?.id)
    }
    
    func test_mapFromEntity_whenMissingId_throwsError() {
        let pattern = buildPatternEntity()
        let codeExampleEntity = buildEntity(id: nil, pattern: pattern)
        
        do {
            _ = try CodeExampleMapper.from(entity: codeExampleEntity)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is CodeExampleError)
        }
    }
    
    func test_mapFromEntity_whenMissingCode_throwsError() {
        let pattern = buildPatternEntity()
        let codeExampleEntity = buildEntity(code: nil, pattern: pattern)
        
        do {
            _ = try CodeExampleMapper.from(entity: codeExampleEntity)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is CodeExampleError)
        }
    }
    
    func test_mapFromEntity_whenMissingPattern_throwsError() {
        let codeExampleEntity = buildEntity(pattern: nil)
        
        do {
            _ = try CodeExampleMapper.from(entity: codeExampleEntity)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is CodeExampleError)
        }
    }
    
    func test_mapToEntity_whenValidInput_success() throws {
        let patternId = UUID()
        let patternEntity = buildPatternEntity(id: patternId)
        let exampleId = UUID()
        let newExample = CodeExample(id: exampleId, patternId: patternId, code: "// Test")
        let mappedEntity = CodeExampleMapper.toEntity(from: newExample, designPattern: patternEntity, context: mockCoreData.testContext)
        
        XCTAssertEqual(mappedEntity.id, exampleId)
        XCTAssertEqual(mappedEntity.code, "// Test")
        XCTAssertEqual(mappedEntity.designPatternRelationship, patternEntity)
    }
}
