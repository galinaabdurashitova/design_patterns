//
//  AndSpecificationTests.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 28.06.2025.
//

import XCTest
@testable import DesignPatterns

final class AndSpecificationTests: XCTestCase {
    func test_andSpecification_success() {
        let specification1 = NameSpecification("e")
        let specification2 = TypeSpecification(.creational)
        let andSpec = AndSpecification(specification1, specification2)
        
        let result1 = andSpec.isSatisfied(TestDesignPatterns.patterns[0])
        XCTAssertFalse(result1)
        
        let result2 = andSpec.isSatisfied(TestDesignPatterns.patterns[1])
        XCTAssertTrue(result2)
        
        let result3 = andSpec.isSatisfied(TestDesignPatterns.patterns[2])
        XCTAssertFalse(result3)
    }
}
