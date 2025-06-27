//
//  DesignPatternRepositoryTests.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 27.06.2025.
//

import XCTest
@testable import DesignPatterns

final class DesignPatternRepositoryTests: XCTestCase {
    private var mockDataSource: MockDesignPatternDataSource!
    private var repository: DesignPatternRepository!

    override func setUp() {
        super.setUp()
        mockDataSource = MockDesignPatternDataSource()
        repository = DesignPatternRepository(dataSource: mockDataSource)
    }

    
}
