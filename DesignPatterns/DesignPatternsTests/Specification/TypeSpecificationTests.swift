//
//  TypeSpecificationTests.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 28.06.2025.
//

import XCTest
@testable import DesignPatterns

final class TypeSpecificationTests: XCTestCase {
    func test_typeSpecification_success() {
        let specification = TypeSpecification(.behavioral)
        
        let result1 = specification.isSatisfied(TestDesignPatterns.patterns[0])
        XCTAssertTrue(result1)
        
        let result2 = specification.isSatisfied(TestDesignPatterns.patterns[1])
        XCTAssertFalse(result2)
    }
}
