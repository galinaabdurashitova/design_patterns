//
//  MultipleTypesSpecificationTests.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 28.06.2025.
//

import XCTest
@testable import DesignPatterns

final class MultipleTypesSpecificationTests: XCTestCase {
    func test_multiTypeSpecification_success() {
        let specification = MultipleTypesSpecification([.creational, .structural])
        
        let result1 = specification.isSatisfied(TestDesignPatterns.patterns[0])
        XCTAssertFalse(result1)
        
        let result2 = specification.isSatisfied(TestDesignPatterns.patterns[1])
        XCTAssertTrue(result2)
    }
}
