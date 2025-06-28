//
//  DesignPatternMapperTests.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 28.06.2025.
//

import XCTest
@testable import DesignPatterns

final class DesignPatternMapperTests: XCTestCase {
    private var mockCoreData: MockCoreDataService!
    
    override func setUp() {
        super.setUp()
        mockCoreData = MockCoreDataService()
    }
    
    private func buildEntity(
        id: UUID? = UUID(),
        name: String? = "Test",
        type: String? = DesignPatternType.behavioral.rawValue,
        patternDescription: String? = "A"
    ) -> DesignPatternEntity {
        let mockPattern = DesignPatternEntity(context: mockCoreData.testContext)
        mockPattern.id = id
        mockPattern.name = name
        mockPattern.type = type
        mockPattern.patternDescription = patternDescription
        return mockPattern
    }

    func test_mapFromEntity_whenValidInput_success() throws {
        let mockPattern = buildEntity()
        let mappedPattern = try DesignPatternMapper.from(entity: mockPattern)
        
        XCTAssertEqual(mappedPattern.id, mockPattern.id)
        XCTAssertEqual(mappedPattern.name, "Test")
        XCTAssertEqual(mappedPattern.type, .behavioral)
        XCTAssertEqual(mappedPattern.patternDescription, "A")
    }
    
    func test_mapFromEntity_whenMissingId_throwsError() {
        let mockPattern = buildEntity(id: nil)
        
        do {
            _ = try DesignPatternMapper.from(entity: mockPattern)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is DesignPatternError)
        }
    }
    
    func test_mapFromEntity_whenMissingName_throwsError() {
        let mockPattern = buildEntity(name: nil)
        
        do {
            _ = try DesignPatternMapper.from(entity: mockPattern)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is DesignPatternError)
        }
    }
    
    func test_mapFromEntity_whenMissingType_throwsError() {
        let mockPattern = buildEntity(type: nil)
        
        do {
            _ = try DesignPatternMapper.from(entity: mockPattern)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is DesignPatternError)
        }
    }
    
    func test_mapFromEntity_whenMissingDescription_throwsError() {
        let mockPattern = buildEntity(patternDescription: nil)
        
        do {
            _ = try DesignPatternMapper.from(entity: mockPattern)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is DesignPatternError)
        }
    }
    
    func test_mapToEntity_whenValidInput_success() throws {
        let patternId = UUID()
        let newPattern = DesignPattern(id: patternId, name: "Test", type: .behavioral, patternDescription: "A")
        let mappedEntity = DesignPatternMapper.toEntity(from: newPattern, context: mockCoreData.testContext)
        
        XCTAssertEqual(mappedEntity.id, patternId)
        XCTAssertEqual(mappedEntity.name, "Test")
        XCTAssertEqual(mappedEntity.type, "behavioral")
        XCTAssertEqual(mappedEntity.patternDescription, "A")
    }
}
