//
//  FastlaneSnapshots.swift
//  FastlaneSnapshots
//
//  Created by Galina Abdurashitova on 18.07.2025.
//

import XCTest

@MainActor
final class DesignPatternsListFastlaneSnapshots: XCTestCase {
    var app: XCUIApplication!
    private let timeout: Double = 30
    private let testsNamePrefix: String = "DesignPatternsList"
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        setupSnapshot(app)
        app.launchArguments += ["--UITests", "-disableAnimations"]
        app.launch()
    }
    
    func snapshot_mainScreenContent_ListView() {
        snapshot("\(testsNamePrefix)_01_ListView")
    }
    
    func snapshot_designPatternView_PatternView_Builder() {
        app.buttons["patternRow-Builder"].tap()
        snapshot("\(testsNamePrefix)_02_PatternView_Builder")
    }
    
    func snapshot_searchBar_ListView_search() {
        let textField = app.textFields["searchTextField"]
        textField.tap()
        textField.typeText("Buil")
        
        snapshot("\(testsNamePrefix)_03_ListView_search")
    }
    
    func snapshot_typeFilterSheet_FilterBottomSheet() {
        let filterButton = app.buttons["filterButton"]
        XCTAssertTrue(filterButton.waitForExistence(timeout: timeout))
        filterButton.tap()
        
        let creational = app.buttons["patternType-creational"]
        let structural = app.buttons["patternType-structural"]
        let doneButton = app.buttons["patternFilterDoneButton"]

        XCTAssertTrue(creational.waitForExistence(timeout: timeout))
        XCTAssertTrue(structural.waitForExistence(timeout: timeout))
        XCTAssertTrue(doneButton.waitForExistence(timeout: timeout))
        
        creational.tap()
        structural.tap()
        
        snapshot("\(testsNamePrefix)_04_FilterBottomSheet")
        
        doneButton.tap()

        let list = app.collectionViews["PatternsList"]
        
        let expectedCell = list.cells.element(boundBy: 1)
        XCTAssertTrue(expectedCell.waitForExistence(timeout: timeout), "Filtered cell did not appear in time")
        
        snapshot("\(testsNamePrefix)_05_ListView_filtered")
    }
}
