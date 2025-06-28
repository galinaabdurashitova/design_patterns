//
//  DesignPatternFilterTests.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 28.06.2025.
//

import XCTest
@testable import DesignPatterns

final class DesignPatternFilterTests: XCTestCase {
    struct MockSpecification: Specification {
        typealias T = DesignPattern
        let isSatisfiedClosure: (DesignPattern) -> Bool

        func isSatisfied(_ item: DesignPattern) -> Bool {
            isSatisfiedClosure(item)
        }
    }
    
    func test_filter_withType_success() {
        let specification = MockSpecification { $0.type == .behavioral }
        let filter = DesignPatternFilter()
        
        let result = filter.filter(items: TestDesignPatterns.patterns, with: specification)
        
        XCTAssertEqual(result.count, 1)
        XCTAssertTrue(result.contains(where: { $0.name == "Specification" }))
        XCTAssertFalse(result.contains(where: { $0.name == "Builder" }))
        XCTAssertFalse(result.contains(where: { $0.name == "Abstract Factory" }))
    }
    
    func test_filter_withName_success() {
        let specification = MockSpecification { $0.name.contains("A") }
        let filter = DesignPatternFilter()
        
        let result = filter.filter(items: TestDesignPatterns.patterns, with: specification)
        
        XCTAssertEqual(result.count, 1)
        XCTAssertTrue(result.contains(where: { $0.name == "Abstract Factory" }))
        XCTAssertFalse(result.contains(where: { $0.name == "Specification" }))
        XCTAssertFalse(result.contains(where: { $0.name == "Builder" }))
    }
}
