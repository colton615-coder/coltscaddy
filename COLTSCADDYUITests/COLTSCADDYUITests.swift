//
//  COLTSCADDYUITests.swift
//  COLTSCADDYUITests
//
//  Created by Colton Thomas on 7/11/26.
//

import XCTest

final class COLTSCADDYUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testSubmittingShotRendersStructuredCaddyCallCard() throws {
        let app = XCUIApplication()
        app.launch()

        app.buttons["+"].tap()

        let distanceField = app.textFields.firstMatch
        XCTAssertTrue(distanceField.waitForExistence(timeout: 2))
        distanceField.tap()
        distanceField.typeText("165")

        app.buttons["Ask the caddie"].tap()

        XCTAssertTrue(app.staticTexts["CADDY CALL"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'Target:'")).firstMatch.exists)
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'Safe miss:'")).firstMatch.exists)
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'Why:'")).firstMatch.exists)
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'Alternate safer:'")).firstMatch.exists)
        XCTAssertTrue(app.buttons["Remind me how"].exists)

        let logResultButton = app.buttons["Log result"]
        XCTAssertTrue(logResultButton.exists)
        XCTAssertTrue(logResultButton.isHittable)

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Phase A Caddy Call Card"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
