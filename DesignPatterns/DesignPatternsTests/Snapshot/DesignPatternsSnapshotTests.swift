//
//  DesignPatternsSnapshotTests.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 29.06.2025.
//

import XCTest
import SnapshotTesting
import SwiftUI
@testable import DesignPatterns

final class DesignPatternsSnapshotTests: XCTestCase {
    private let record: Bool = false
    
    @MainActor
    func test_mainScreen_snapshot() {
        let view = DesignPatternsListView(
            viewModel: DesignPatternsListViewModel(
                patterns: TestDesignPatterns.patterns,
                useCase: MockDesignPatternUseCase()
            )
        )
        let vc = UIHostingController(rootView: view)

        assertSnapshot(
            of: vc,
            as: .image(on: .iPhone13),
            record: record
        )
    }
    
    @MainActor
    func test_patternView_snapshot() {
        let view = DesignPatternView(
            selectedPattern: MockDesignPatterns.patterns[0],
            closeButtonAction: { }
        )
        let vc = UIHostingController(rootView: view)
        
        assertSnapshot(
            of: vc,
            as: .image(on: .iPhone13),
            record: record
        )
    }
    
    @MainActor
    func test_typeFilterView_snapshot() {
        let view = TypeFilterView(isPresented: .constant(true), selectedTypes: .constant([.behavioral]))
        let vc = UIHostingController(rootView: view)
        
        assertSnapshot(
            of: vc,
            as: .image(on: .iPhone13),
            record: record
        )
    }
}
