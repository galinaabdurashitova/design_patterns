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
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["--UITests", "-disableAnimations"]
        app.launch()
    }

    func test_mainScreenContent_showsPatternsContent() {
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
    
    func test_designPatternView_showsPatternDetailsAndCloses() {
        app.buttons["patternRow-Builder"].tap()
        
        let designPatternView = app.staticTexts["patternView-Builder"]
        XCTAssertTrue(designPatternView.exists)
        
        let list = app.collectionViews["PatternsList"]
        XCTAssertFalse(list.isEnabled)
        
        app.buttons["patternViewCloseButton"].tap()
        
        XCTAssertTrue(designPatternView.waitForNonExistence(timeout: timeout))
    }
    
    func test_searchBar_searchesPatterns() {
        let textField = app.textFields["searchTextField"]
        textField.tap()
        textField.typeText("Buil")
        
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
        
        XCTAssertTrue(doneButton.isHittable, "Done button is not tappable")
        doneButton.tap()

        let list = app.collectionViews["PatternsList"]
        
        let expectedCell = list.cells.element(boundBy: 1)
        XCTAssertTrue(expectedCell.waitForExistence(timeout: timeout), "Filtered cell did not appear in time")
        
        XCTAssertEqual(list.cells.count, 2)
        XCTAssertEqual(filterButton.label, "2 types")
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
