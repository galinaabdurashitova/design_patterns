//
//  DesignPatternsSnapshotTests.swift
//  DesignPatternsSnapshotTests
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
            viewModel: MockDesignPatternsListViewModel()
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
    
    @MainActor
    func test_newPatternView_snapshot() {
        let view = NewPatternView(viewModel: MockNewPatternViewModel(), isPresented: .constant(true), onPatternAdd: { })
        let vc = UIHostingController(rootView: view)
        
        assertSnapshot(
            of: vc,
            as: .image(on: .iPhone13),
            record: record
        )
    }
    
    @MainActor
    func test_newPattern_nameInput_snapshot() {
        let view = NewPatternNameInputView(viewModel: MockNewPatternViewModel())
        let vc = UIHostingController(rootView: view)
        
        assertSnapshot(
            of: vc,
            as: .image(on: .iPhone13),
            record: record
        )
    }
    
    @MainActor
    func test_patternType_snapshot() {
        let view = NewPatternChooseTypeView(viewModel: MockNewPatternViewModel())
        let vc = UIHostingController(rootView: view)
        
        assertSnapshot(
            of: vc,
            as: .image(on: .iPhone13),
            record: record
        )
    }
    
    @MainActor
    func test_patternDescription_snapshot() {
        let view = NewPatternDescriptionInputView(viewModel: MockNewPatternViewModel())
        let vc = UIHostingController(rootView: view)
        
        assertSnapshot(
            of: vc,
            as: .image(on: .iPhone13),
            record: record
        )
    }
    
    @MainActor
    func test_patternCodeExamples_snapshot() {
        let view = NewPatternCodeExamplesView(viewModel: MockNewPatternViewModel())
        let vc = UIHostingController(rootView: view)
        
        assertSnapshot(
            of: vc,
            as: .image(on: .iPhone13),
            record: record
        )
    }
    
    @MainActor
    func test_patternConfirm_snapshot() {
        let view = NewPatternConfirmView(viewModel: MockNewPatternViewModel())
        let vc = UIHostingController(rootView: view)
        
        assertSnapshot(
            of: vc,
            as: .image(on: .iPhone13),
            record: record
        )
    }
}

