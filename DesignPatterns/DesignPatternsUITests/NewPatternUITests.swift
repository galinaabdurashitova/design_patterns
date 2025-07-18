//
//  NewPatternUITests.swift
//  DesignPatternsUITests
//
//  Created by Galina Abdurashitova on 06.07.2025.
//

import XCTest

final class NewPatternUITests: XCTestCase {
    var app: XCUIApplication!
    
    private let timeout: Double = 30
    
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
    
    func test_addPatternSheet_nameInputStep() {
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
    
    func test_addPatternSheet_patternTypeStep() {
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
    
    func test_addPatternSheet_descriptionInputStep() {
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
    
    func test_addPatternSheet_codeExamplesStep() {
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
        
        let textField = firstField.textViews.firstMatch
        XCTAssertEqual(textField.value as? String, "Test2")
        waitForNextStepButtonEnabled()
        
        prev.tap()
        let descriptionInputTextView = app.textFields["addPatternDescriptionTextField"]
        XCTAssertTrue(descriptionInputTextView.waitForExistence(timeout: timeout))
    }
    
    func test_addPatternSheet_confirmView_when3AndLessCodeExamples() {
        openNewPatternSheet()
        
        let testName = "Test name"
        let testType = "behavioral"
        let testDescription = "Test description"
        let testCodeExamples = ["Code example 1", "Code example 2"]
        
        NewPatternRobot(app: app, timeout: timeout)
            .fillName(testName)
            .pickType(testType)
            .fillDescription(testDescription)
            .addCodeExamples(testCodeExamples)
        
        checkStepAtStart(stepN: 5)
        
        let nameTextField = app.staticTexts["addPatternConfirmField-Name"]
        XCTAssertEqual(nameTextField.label, testName)
        let typeTextField = app.staticTexts["addPatternConfirmField-Type"]
        XCTAssertTrue(typeTextField.label.lowercased().contains(testType))
        let descriptionTextField = app.staticTexts["addPatternConfirmField-Description"]
        XCTAssertEqual(descriptionTextField.label, testDescription)
        for i in testCodeExamples.indices {
            let codeExampleTextFiled = app.scrollViews["addPatternConfirmField-codeExample-\(i)"]
            let textField = codeExampleTextFiled.textViews.firstMatch
            XCTAssertEqual(textField.value as? String, testCodeExamples[i])
        }
    }
    
    func test_addPatternSheet_confirmView_whenMoreThan3CodeExamples() {
        openNewPatternSheet()
        
        let testCodeExamples = ["Code example 1", "Code example 2", "Code example 3", "Code example 4"]
        
        NewPatternRobot(app: app, timeout: timeout)
            .fillName()
            .pickType()
            .fillDescription()
            .addCodeExamples(testCodeExamples)
        
        for i in 0..<3 {
            let codeExampleTextFiled = app.scrollViews["addPatternConfirmField-codeExample-\(i)"]
            let textField = codeExampleTextFiled.textViews.firstMatch
            XCTAssertEqual(textField.value as? String, testCodeExamples[i])
        }
        
        let nextCodeField = app.scrollViews["addPatternConfirmField-codeExample-\(3)"]
        XCTAssertFalse(nextCodeField.exists)
        let button = app.buttons["addPatternConfirmField-codeExamplesExpandButton"]
        XCTAssertTrue(button.exists)
        button.tap()
        XCTAssertTrue(nextCodeField.waitForExistence(timeout: timeout))
        let textField = nextCodeField.textViews.firstMatch
        XCTAssertEqual(textField.value as? String, testCodeExamples[3])
        button.tap()
        XCTAssertTrue(nextCodeField.waitForNonExistence(timeout: timeout))
    }
    
    func test_addPatternSheet_confirmView_goBack() {
        openNewPatternSheet()
        NewPatternRobot(app: app, timeout: timeout)
            .fillName()
            .pickType()
            .fillDescription()
            .addCodeExamples()
        
        let enabledPredicate = NSPredicate(format: "exists == true")
        let enabledExpectation = expectation(
            for: enabledPredicate,
            evaluatedWith: prev,
            handler: nil
        )
        wait(for: [enabledExpectation], timeout: timeout)
        XCTAssertTrue(prev.exists)
        prev.tap()
        
        let codeExampleField = app.scrollViews["addPatternCodeExampleTextField-0"]
        XCTAssertTrue(codeExampleField.waitForExistence(timeout: timeout))
    }
    
    func test_addPatternSheet_saveNewPattern() {
        openNewPatternSheet()
        
        let newPatternName = "Test"
        
        NewPatternRobot(app: app, timeout: timeout)
            .fillName(newPatternName)
            .pickType()
            .fillDescription()
            .addCodeExamples()
        
        let nameTextField = app.staticTexts["addPatternConfirmField-Name"]
        XCTAssertTrue(nameTextField.waitForExistence(timeout: timeout))
        
        next.tap()
        
        let closeButton = app.buttons["closeSheetButton"]
        XCTAssertTrue(closeButton.waitForNonExistence(timeout: timeout))
        
        let newPattern = app.buttons["patternRow-\(newPatternName)"]
        XCTAssertTrue(newPattern.waitForExistence(timeout: timeout))
    }
    
    // MARK: Private helper methods
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
