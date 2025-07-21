//
//  XCUIElementQuery+waitUntilCount.swift
//  DesignPatternsUITests
//
//  Created by Galina Abdurashitova on 21.07.2025.
//

import Foundation
import XCTest

extension XCUIElementQuery {
    func waitUntilCount(_ expected: Int,
                        timeout: TimeInterval,
                        file: StaticString = #file,
                        line: UInt = #line) -> Bool {
        let predicate = NSPredicate(format: "count == %d", expected)
        let exp = XCTNSPredicateExpectation(predicate: predicate, object: self)
        let result = XCTWaiter().wait(for: [exp], timeout: timeout)
        if result != .completed {
            XCTFail("Expected \(expected) cells, got \(self.count)",
                    file: file, line: line)
        }
        return result == .completed
    }
}
