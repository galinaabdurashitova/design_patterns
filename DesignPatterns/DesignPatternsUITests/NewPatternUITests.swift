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
    
    private var next: XCUIElement      { app.buttons["nextStepButton"] }
    private var prev: XCUIElement      { app.buttons["previousStepButton"] }
    
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
        checkStepAtStart(stepN: 1)
        
        XCTAssertTrue(next.exists)
        XCTAssertFalse(next.isEnabled)
        
        let nameInputTextField = app.textFields["addPatternNameTextField"]
        XCTAssertTrue(nameInputTextField.exists)
        nameInputTextField.tap()
        nameInputTextField.typeText("Test")
        waitForNextStepButtonEnabled()
    }
    
    func test_addPatternSheet_patternType() {
        openNewPatternSheet()
        
        NewPatternRobot(app: app, timeout: timeout)
            .fillName()
        
        checkStepAtStart(stepN: 2)
        
        let creationalTypeButton = app.buttons["addPatternType-creational"]
        XCTAssertTrue(creationalTypeButton.exists)
        let structuralTypeButton = app.buttons["addPatternType-structural"]
        XCTAssertTrue(structuralTypeButton.exists)
        let behavioralTypeButton = app.buttons["addPatternType-behavioral"]
        XCTAssertTrue(behavioralTypeButton.exists)
        behavioralTypeButton.tap()
        waitForNextStepButtonEnabled()
        
        prev.tap()
        let nameInputTextField = app.textFields["addPatternNameTextField"]
        XCTAssertTrue(nameInputTextField.waitForExistence(timeout: timeout))
    }
    
    func test_addPatternSheet_descriptionInput() {
        openNewPatternSheet()
        
        NewPatternRobot(app: app, timeout: timeout)
            .fillName()
            .pickType()
        
        checkStepAtStart(stepN: 3)
        
        let descriptionInputTextView = app.textFields["addPatternDescriptionTextField"]
        XCTAssertTrue(descriptionInputTextView.waitForExistence(timeout: timeout))
        descriptionInputTextView.tap()
        descriptionInputTextView.typeText("Test")
        waitForNextStepButtonEnabled()
        
        prev.tap()
        let behavioralTypeButton = app.buttons["addPatternType-behavioral"]
        XCTAssertTrue(behavioralTypeButton.waitForExistence(timeout: timeout))
    }
    
    func test_addPatternSheet_codeExamples() {
        openNewPatternSheet()
        
        NewPatternRobot(app: app, timeout: timeout)
            .fillName()
            .pickType()
            .fillDescription()
        
        checkStepAtStart(stepN: 4)
        
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
        
        prev.tap()
        let descriptionInputTextView = app.textFields["addPatternDescriptionTextField"]
        XCTAssertTrue(descriptionInputTextView.waitForExistence(timeout: timeout))
    }
    
    private func openNewPatternSheet() {
        let addButton = app.buttons["addPatternButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: timeout))
        addButton.tap()
    }
    
    private func waitForNextStepButtonEnabled() {
        let enabledPredicate = NSPredicate(format: "isEnabled == true")
        let enabledExpectation = expectation(
            for: enabledPredicate,
            evaluatedWith: next,
            handler: nil
        )
        wait(for: [enabledExpectation], timeout: timeout)
        XCTAssertTrue(next.isEnabled)
    }
    
    private func checkStepAtStart(stepN: Int) {
        let text = app.staticTexts["addPatternTitle"]
        XCTAssertTrue(text.waitForExistence(timeout: timeout))
        XCTAssertEqual(text.label, "Add new design pattern \(stepN)/5")
        
        XCTAssertTrue(stepN == 1 ? !prev.exists : prev.exists)
    }
}
