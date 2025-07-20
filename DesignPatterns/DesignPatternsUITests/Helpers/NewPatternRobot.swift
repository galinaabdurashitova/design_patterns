//
//  NewPatternRobot.swift
//  DesignPatternsUITests
//
//  Created by Galina Abdurashitova on 06.07.2025.
//

import XCTest

struct NewPatternRobot {
    let app: XCUIApplication
    let timeout: Double

    private var next: XCUIElement      { app.buttons["nextStepButton"] }
    private var prev: XCUIElement      { app.buttons["previousStepButton"] }

    @discardableResult
    func fillName(_ text: String = "Test") -> Self {
        let field = app.textFields["addPatternNameTextField"]
        XCTAssertTrue(field.waitForExistence(timeout: timeout))
        field.tap()
        field.typeText(text)
        waitEnabled(next, timeout: timeout).tap()
        waitEnabled(next, timeout: timeout, enabled: false)
        return self
    }

    @discardableResult
    func pickType(_ type: String = "behavioral") -> Self {
        app.buttons["addPatternType-\(type)"].tap()
        waitEnabled(next, timeout: timeout).tap()
        waitEnabled(next, timeout: timeout, enabled: false)
        return self
    }

    @discardableResult
    func fillDescription(_ text: String = "Demo") -> Self {
        let field = app.textFields["addPatternDescriptionTextField"]
        XCTAssertTrue(field.waitForExistence(timeout: timeout))
        field.tap()
        field.typeText(text)
        waitEnabled(next, timeout: timeout).tap()
        waitEnabled(next, timeout: timeout, enabled: false)
        return self
    }
    
    @discardableResult
    func addCodeExamples(_ codeExamples: [String] = ["Test", "Test2"]) -> Self {
        for i in codeExamples.indices {
            let field = app.scrollViews["addPatternCodeExampleTextField-\(i)"]
            XCTAssertTrue(field.waitForExistence(timeout: timeout))
            field.tap()
            field.typeText(codeExamples[i])
            app.buttons["addPatternCodeExampleButton"].tap()
        }
        waitEnabled(next, timeout: timeout).tap()
        return self
    }

    @discardableResult
    private func waitEnabled(
        _ element: XCUIElement,
        timeout: TimeInterval = 60,
        enabled: Bool = true
    ) -> XCUIElement {
        let predicate = NSPredicate(format: "isEnabled == \(enabled ? "true" : "false")")
        let exp = XCTNSPredicateExpectation(predicate: predicate, object: element)
        XCTAssertEqual(
            XCTWaiter().wait(for: [exp], timeout: timeout),
            .completed
        )
        return element
    }
}
