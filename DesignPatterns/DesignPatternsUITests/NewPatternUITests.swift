//
//  NewPatternUITests.swift
//  DesignPatternsUITests
//
//  Created by Galina Abdurashitova on 06.07.2025.
//

import XCTest

final class NewPatternUITests: XCTestCase {
    var app: XCUIApplication!
    
    private let timeout: Double = 10
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["--UITests", "-disableAnimations"]
        app.launch()
    }
    
    func test_addPatternSheet_opensAndCloses() {
        openNewPatternSheet()
        let closeButton = app.buttons["closeSheetButton"]
        XCTAssertTrue(closeButton.waitForExistence(timeout: timeout))
        closeButton.tap()
        XCTAssertTrue(closeButton.waitForNonExistence(timeout: timeout))
    }
    
    func test_addPatternSheet_nameField() {
        openNewPatternSheet()
        
        let text = app.staticTexts["addPatternTitle"]
        XCTAssertTrue(text.waitForExistence(timeout: timeout))
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
        wait(for: [enabledExpectation], timeout: timeout)
        XCTAssertTrue(nextStepButton.isEnabled)
    }
    
    func test_addPatternSheet_patternType() {
        openNewPatternSheet()
        
        NewPatternRobot(app: app, timeout: timeout)
            .fillName()
        
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
        
        let nextStepButton = app.buttons["nextStepButton"]
        XCTAssertTrue(nextStepButton.isEnabled)
        
        previousStepButton.tap()
        let nameInputTextField = app.textFields["addPatternNameTextField"]
        XCTAssertTrue(nameInputTextField.waitForExistence(timeout: timeout))
    }
    
    func test_addPatternSheet_descriptionInput() {
        openNewPatternSheet()
        
        NewPatternRobot(app: app, timeout: timeout)
            .fillName()
            .pickType()
        
        let text = app.staticTexts["addPatternTitle"]
        XCTAssertEqual(text.label, "Add new design pattern 3/5")
        let previousStepButton = app.buttons["previousStepButton"]
        XCTAssertTrue(previousStepButton.exists)
        
        let descriptionInputTextView = app.textFields["addPatternDescriptionTextField"]
        XCTAssertTrue(descriptionInputTextView.waitForExistence(timeout: timeout))
        descriptionInputTextView.tap()
        descriptionInputTextView.typeText("Test")
        
        let nextStepButton = app.buttons["nextStepButton"]
        XCTAssertTrue(nextStepButton.isEnabled)
        
        previousStepButton.tap()
        let behavioralTypeButton = app.buttons["addPatternType-behavioral"]
        XCTAssertTrue(behavioralTypeButton.waitForExistence(timeout: timeout))
    }
    
    func test_addPatternSheet_codeExamples() {
        openNewPatternSheet()
        
        NewPatternRobot(app: app, timeout: timeout)
            .fillName()
            .pickType()
            .fillDescription()
        
        let text = app.staticTexts["addPatternTitle"]
        XCTAssertEqual(text.label, "Add new design pattern 4/5")
        let previousStepButton = app.buttons["previousStepButton"]
        XCTAssertTrue(previousStepButton.exists)
        
        let codeExamplesFields = app.textViews
        XCTAssertEqual(codeExamplesFields.count, 1)
        
        let addCodeExampleButton = app.buttons["addPatternCodeExampleButton"]
        addCodeExampleButton.tap()
        XCTAssertEqual(codeExamplesFields.count, 1)
        
        let firstField = app.scrollViews["addPatternCodeExampleTextField-0"]
        firstField.tap()
        firstField.typeText("Test")
        let deleteCodeExampleButton = app.buttons["addPatternCodeExampleDeleteExample-0"]
        XCTAssertTrue(deleteCodeExampleButton.exists)
        
        addCodeExampleButton.tap()
        XCTAssertEqual(codeExamplesFields.count, 2)
        
        let secondField = app.scrollViews["addPatternCodeExampleTextField-1"]
        secondField.tap()
        secondField.typeText("Test2")
        
        deleteCodeExampleButton.tap()
        XCTAssertTrue(secondField.waitForNonExistence(timeout: timeout))
//        XCTAssertEqual(firstField.label, "Test2")
//        
//        let nextStepButton = app.buttons["nextStepButton"]
//        XCTAssertTrue(nextStepButton.isEnabled)
        
        previousStepButton.tap()
        let descriptionInputTextView = app.textFields["addPatternDescriptionTextField"]
        XCTAssertTrue(descriptionInputTextView.waitForExistence(timeout: timeout))
    }
    
    private func openNewPatternSheet() {
        let addButton = app.buttons["addPatternButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: timeout))
        addButton.tap()
    }
}
