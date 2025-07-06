//
//  NewPatternRobot.swift
//  DesignPatternsUITests
//
//  Created by Galina Abdurashitova on 06.07.2025.
//

import XCTest

struct NewPatternRobot {
    let app: XCUIApplication

    private var next: XCUIElement      { app.buttons["nextStepButton"] }
    private var prev: XCUIElement      { app.buttons["previousStepButton"] }

    @discardableResult
    func fillName(_ text: String = "Test") -> Self {
        let field = app.textFields["addPatternNameTextField"]
        XCTAssertTrue(field.waitForExistence(timeout: 1.5))
        field.tap()
        field.typeText(text)
        waitEnabled(next).tap()
        waitEnabled(next, enabled: false)
        return self
    }

    @discardableResult
    func pickType(_ type: String = "behavioral") -> Self {
        app.buttons["addPatternType-\(type)"].tap()
        waitEnabled(next).tap()
        waitEnabled(next, enabled: false)
        return self
    }

    @discardableResult
    func fillDescription(_ text: String = "Demo") -> Self {
        let field = app.textFields["addPatternDescriptionTextField"]
        XCTAssertTrue(field.waitForExistence(timeout: 1.5))
        field.tap()
        field.typeText(text)
        waitEnabled(next).tap()
        waitEnabled(next, enabled: false)
        return self
    }

    @discardableResult
    private func waitEnabled(
        _ element: XCUIElement,
        timeout: TimeInterval = 3,
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
