//
//  DesignPatternsUITests.swift
//  DesignPatternsUITests
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import XCTest

final class DesignPatternsListUITests: XCTestCase {
    var app: XCUIApplication!
    private let timeout: Double = 30
    private let testsNamePrefix: String = "DesignPatternsList"
    
    @MainActor
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        setupSnapshot(app)
        app.launchArguments += ["--UITests", "-disableAnimations"]
        app.launch()
    }
    
    @MainActor
    func test_mainScreenContent_showsPatternsContent() {
        snapshot("\(testsNamePrefix)_01_ListView")
        let list = app.collectionViews["PatternsList"]
        XCTAssertEqual(list.cells.count, 3)
    }
    
    func test_mainScreenContent_filtersAreClearedOnLaunch() {
        let textField = app.textFields["searchTextField"]
        XCTAssertEqual(textField.placeholderValue, "Search patterns")
        
        let clearButton = app.buttons["searchClearButton"]
        XCTAssertFalse(clearButton.exists)
        
        let typeButton = app.buttons["filterButton"]
        XCTAssertEqual(typeButton.label, "Type")
    }
    
    @MainActor
    func test_designPatternView_showsPatternDetailsAndCloses() {
        app.buttons["patternRow-Builder"].tap()
        
        let designPatternView = app.staticTexts["patternView-Builder"]
        XCTAssertTrue(designPatternView.exists)
        
        snapshot("\(testsNamePrefix)_02_PatternView_Builder")
        
        let list = app.collectionViews["PatternsList"]
        XCTAssertFalse(list.isEnabled)
        
        app.buttons["patternViewCloseButton"].tap()
        
        XCTAssertTrue(designPatternView.waitForNonExistence(timeout: timeout))
    }
    
    @MainActor
    func test_searchBar_searchesPatterns() {
        let textField = app.textFields["searchTextField"]
        textField.tap()
        textField.typeText("Buil")
        
        snapshot("\(testsNamePrefix)_03_ListView_search")
        
        let list = app.collectionViews["PatternsList"]
        
        let firstCell = list.cells.element(boundBy: list.cells.count-1)
        XCTAssertTrue(firstCell.waitForNonExistence(timeout: timeout))
        
        XCTAssertEqual(list.cells.count, 1)
    }
    
    func test_searchBar_clearsSearch() {
        let textField = app.textFields["searchTextField"]
        textField.tap()
        textField.typeText("Buil")
        
        let clearButton = app.buttons["searchClearButton"]
        XCTAssertTrue(clearButton.exists)
        
        clearButton.tap()
        XCTAssertFalse(clearButton.exists)
        
        XCTAssertEqual(textField.placeholderValue, "Search patterns")
    }
    
    @MainActor
    func test_typeFilterSheet_filtersPatterns() {
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
        
        XCTAssertTrue(doneButton.isHittable, "Done button is not tappable")
        doneButton.tap()

        let list = app.collectionViews["PatternsList"]
        
        let expectedCell = list.cells.element(boundBy: 1)
        XCTAssertTrue(expectedCell.waitForExistence(timeout: timeout), "Filtered cell did not appear in time")
        
        XCTAssertEqual(list.cells.count, 2)
        XCTAssertEqual(filterButton.label, "2 types")
        
        snapshot("\(testsNamePrefix)_05_ListView_filtered")
    }

    
    func test_typeFilterSheet_closeSheet() {
        app.buttons["filterButton"].tap()
        
        let sheetBackground = app.otherElements["PopoverDismissRegion"]
        XCTAssertTrue(sheetBackground.waitForExistence(timeout: timeout))
        
        let coordinate = app.coordinate(
            withNormalizedOffset: CGVector(dx: 0.5, dy: 0.3)
        )
        coordinate.tap()
        
        XCTAssertTrue(sheetBackground.waitForNonExistence(timeout: timeout))
        
        let list = app.collectionViews["PatternsList"]
        XCTAssertEqual(list.cells.count, 3)
    }
}
