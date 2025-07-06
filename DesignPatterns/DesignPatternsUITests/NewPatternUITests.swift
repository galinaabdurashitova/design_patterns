//
//  NewPatternUITests.swift
//  DesignPatternsUITests
//
//  Created by Galina Abdurashitova on 06.07.2025.
//

import XCTest

final class NewPatternUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--UITests")
        app.launch()
    }
    
    func test_addPatternSheet_opensAndCloses() {
        openNewPatternSheet()
        let closeButton = app.buttons["closeSheetButton"]
        XCTAssertTrue(closeButton.waitForExistence(timeout: 0.5))
        closeButton.tap()
        XCTAssertTrue(closeButton.waitForNonExistence(timeout: 0.5))
    }
    
    func test_addPatternSheet_nameField() {
        openNewPatternSheet()
        
        let text = app.staticTexts["addPatternTitle"]
        XCTAssertTrue(text.waitForExistence(timeout: 0.5))
        XCTAssertEqual(text.label, "Add new design pattern 1/5")
        
        let previousStepButton = app.buttons["previousStepButton"]
        XCTAssertFalse(previousStepButton.exists)
        let nextStepButton = app.buttons["nextStepButton"]
        XCTAssertTrue(nextStepButton.exists)
        XCTAssertFalse(nextStepButton.isEnabled)
        
        let nameInputTextField = app.textFields["addPatternNameTextField"]
        XCTAssertTrue(nameInputTextField.exists)
        nameInputTextField.tap()
        nameInputTextField.typeText("Test")
        let enabledPredicate = NSPredicate(format: "isEnabled == true")
        let enabledExpectation = expectation(
            for: enabledPredicate,
            evaluatedWith: nextStepButton,
            handler: nil
        )
        wait(for: [enabledExpectation], timeout: 1.5)
        XCTAssertTrue(nextStepButton.isEnabled)
    }
    
    func test_addPatternSheet_patternType() {
        openNewPatternSheet()
        
        NewPatternRobot(app: app)
            .fillName()
        
        let nextStepButton = app.buttons["nextStepButton"]
        XCTAssertFalse(nextStepButton.isEnabled)
        let text = app.staticTexts["addPatternTitle"]
        XCTAssertEqual(text.label, "Add new design pattern 2/5")
        let previousStepButton = app.buttons["previousStepButton"]
        XCTAssertTrue(previousStepButton.exists)
        
        let creationalTypeButton = app.buttons["addPatternType-creational"]
        XCTAssertTrue(creationalTypeButton.exists)
        let structuralTypeButton = app.buttons["addPatternType-structural"]
        XCTAssertTrue(structuralTypeButton.exists)
        let behavioralTypeButton = app.buttons["addPatternType-behavioral"]
        XCTAssertTrue(behavioralTypeButton.exists)
        
        behavioralTypeButton.tap()
        XCTAssertTrue(nextStepButton.isEnabled)
        
        previousStepButton.tap()
        let nameInputTextField = app.textFields["addPatternNameTextField"]
        XCTAssertTrue(nameInputTextField.waitForExistence(timeout: 0.5))
    }
    
    func test_addPatternSheet_descriptionInput() {
        openNewPatternSheet()
        
        NewPatternRobot(app: app)
            .fillName()
            .pickType()
        
        let nextStepButton = app.buttons["nextStepButton"]
        XCTAssertFalse(nextStepButton.isEnabled)
        let text = app.staticTexts["addPatternTitle"]
        XCTAssertEqual(text.label, "Add new design pattern 3/5")
        let previousStepButton = app.buttons["previousStepButton"]
        XCTAssertTrue(previousStepButton.exists)
        
        let descriptionInputTextView = app.textFields["addPatternDescriptionTextField"]
        XCTAssertTrue(descriptionInputTextView.waitForExistence(timeout: 0.5))
        descriptionInputTextView.tap()
        descriptionInputTextView.typeText("Test")
        XCTAssertTrue(nextStepButton.isEnabled)
        
        previousStepButton.tap()
        let behavioralTypeButton = app.buttons["addPatternType-behavioral"]
        XCTAssertTrue(behavioralTypeButton.waitForExistence(timeout: 0.5))
    }
    
    func test_addPatternSheet_codeExamples() {
        openNewPatternSheet()
        
        NewPatternRobot(app: app)
            .fillName()
            .pickType()
            .fillDescription()
        
        let nextStepButton = app.buttons["nextStepButton"]
        XCTAssertFalse(nextStepButton.isEnabled)
        let text = app.staticTexts["addPatternTitle"]
        XCTAssertEqual(text.label, "Add new design pattern 4/5")
        let previousStepButton = app.buttons["previousStepButton"]
        XCTAssertTrue(previousStepButton.exists)
        
        // continue
        
        previousStepButton.tap()
        let descriptionInputTextView = app.textFields["addPatternDescriptionTextField"]
        XCTAssertTrue(descriptionInputTextView.waitForExistence(timeout: 0.5))
    }
    
    private func openNewPatternSheet() {
        let addButton = app.buttons["addPatternButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 0.5))
        addButton.tap()
    }
}
