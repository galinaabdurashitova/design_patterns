//
//  NameSpecificationTests.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 28.06.2025.
//

import XCTest
@testable import DesignPatterns

final class NameSpecificationTests: XCTestCase {
    func test_nameSpecification_success() {
        let specification = NameSpecification("Buil")
        
        let result1 = specification.isSatisfied(TestDesignPatterns.patterns[0])
        XCTAssertFalse(result1)
        
        let result2 = specification.isSatisfied(TestDesignPatterns.patterns[1])
        XCTAssertTrue(result2)
    }
}
