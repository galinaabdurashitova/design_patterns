//
//  NewPatternFastlaneSnapshots.swift
//  FastlaneSnapshots
//
//  Created by Galina Abdurashitova on 18.07.2025.
//

import XCTest

@MainActor
final class NewPatternFastlaneSnapshots: XCTestCase {
    var app: XCUIApplication!
    
    private let timeout: Double = 30
    private let testsNamePrefix: String = "NewPattern"
    
    private var next: XCUIElement      { app.buttons["nextStepButton"] }
    private var prev: XCUIElement      { app.buttons["previousStepButton"] }

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        setupSnapshot(app)
        app.launchArguments += ["--UITests", "-disableAnimations"]
        app.launch()
    }
    
    func snapshot_addPatternSheet_nameInputStep() {
        openNewPatternSheet()
        checkStepAtStart()
        snapshot("\(testsNamePrefix)_01_NewPatternName")
    }
    
    func snapshot_addPatternSheet_patternTypeStep() {
        openNewPatternSheet()
        
        NewPatternRobot(app: app, timeout: timeout)
            .fillName()
        
        checkStepAtStart()
        
        let behavioralTypeButton = app.buttons["addPatternType-behavioral"]
        behavioralTypeButton.tap()
        
        snapshot("\(testsNamePrefix)_02_NewPatternType")
    }
    
    func test_addPatternSheet_descriptionInputStep() {
        openNewPatternSheet()
        
        NewPatternRobot(app: app, timeout: timeout)
            .fillName()
            .pickType()
        
        checkStepAtStart()
        snapshot("\(testsNamePrefix)_03_NewPatternDescription")
    }
    
    func snapshot_addPatternSheet_codeExamplesStep() {
        openNewPatternSheet()
        
        NewPatternRobot(app: app, timeout: timeout)
            .fillName()
            .pickType()
            .fillDescription()
        
        checkStepAtStart()
        
        let firstField = app.scrollViews["addPatternCodeExampleTextField-0"]
        firstField.tap()
        firstField.typeText("let i = 10")
        
        let addCodeExampleButton = app.buttons["addPatternCodeExampleButton"]
        addCodeExampleButton.tap()
        
        let secondField = app.scrollViews["addPatternCodeExampleTextField-1"]
        secondField.tap()
        secondField.typeText("func getPatterns() { }")
        
        snapshot("\(testsNamePrefix)_05_NewPatternCodeExamples")
    }
    
    func snapshot_addPatternSheet_confirmView_when3AndLessCodeExamples() {
        openNewPatternSheet()
        
        let testName = "Test name"
        let testType = "behavioral"
        let testDescription = "Test description"
        let testCodeExamples = ["let i = 10", "func getPatterns() { }"]
        
        NewPatternRobot(app: app, timeout: timeout)
            .fillName(testName)
            .pickType(testType)
            .fillDescription(testDescription)
            .addCodeExamples(testCodeExamples)
        
        checkStepAtStart()
        snapshot("\(testsNamePrefix)_06_NewPatternConfirm")
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
    }
    
    private func checkStepAtStart() {
        let text = app.staticTexts["addPatternTitle"]
        XCTAssertTrue(text.waitForExistence(timeout: timeout))
    }
}
