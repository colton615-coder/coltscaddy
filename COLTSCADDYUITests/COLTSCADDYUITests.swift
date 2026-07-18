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

        let distanceField = app.textFields["shotDistanceField"]
        XCTAssertTrue(distanceField.waitForExistence(timeout: 2))
        distanceField.tap()
        distanceField.typeText("165")

        app.buttons["Ask the caddie"].tap()

        XCTAssertTrue(app.staticTexts["This is a stock club for you."].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["CADDY CALL"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["7 Iron"].exists)
        XCTAssertTrue(app.staticTexts["165 yds"].exists)
        XCTAssertTrue(app.staticTexts["Medium-high"].exists)
        XCTAssertTrue(app.staticTexts["Target"].exists)
        XCTAssertTrue(app.staticTexts["Safe miss"].exists)
        XCTAssertTrue(app.staticTexts["Why"].exists)
        XCTAssertTrue(app.staticTexts["Alternate"].exists)

        let executionTip = app.staticTexts[
            "Set the face, settle your feet, and make the same committed swing you use on the range."
        ]
        let remindButton = app.buttons["Remind me how"]
        XCTAssertTrue(remindButton.exists)
        XCTAssertFalse(executionTip.exists)

        remindButton.tap()

        XCTAssertTrue(executionTip.waitForExistence(timeout: 2))

        let logResultButton = app.buttons["Log result"]
        XCTAssertTrue(logResultButton.exists)
        XCTAssertTrue(logResultButton.isHittable)
        XCTAssertTrue(logResultButton.isEnabled)

        let expandedTipAttachment = XCTAttachment(screenshot: app.screenshot())
        expandedTipAttachment.name = "Expanded Full-Shot Execution Tip"
        expandedTipAttachment.lifetime = .keepAlways
        add(expandedTipAttachment)

        XCTAssertTrue(remindButton.isHittable)
        remindButton.tap()
        XCTAssertFalse(executionTip.exists)

        logResultButton.tap()

        XCTAssertFalse(logResultButton.isEnabled)

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Phase 5.3 Short Caddie Lead"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testTypedNuanceAttachesToTheNextSubmittedShotAndClears() throws {
        let app = XCUIApplication()
        app.launch()

        let nuanceField = app.textFields["nuanceTextField"]
        let nuanceButton = app.buttons["nuanceSendButton"]
        XCTAssertTrue(nuanceField.waitForExistence(timeout: 2))
        XCTAssertFalse(nuanceButton.isEnabled)

        nuanceField.tap()
        nuanceField.typeText("Ball below my feet.")
        XCTAssertTrue(nuanceButton.isEnabled)
        nuanceButton.tap()

        let distanceField = app.textFields["shotDistanceField"]
        XCTAssertTrue(distanceField.waitForExistence(timeout: 2))
        distanceField.tap()
        distanceField.typeText("165")
        app.buttons["Ask the caddie"].tap()

        XCTAssertTrue(
            app.staticTexts["165 yards, fairway, full shot, no trouble marked. Nuance: Ball below my feet."]
                .waitForExistence(timeout: 5)
        )
        XCTAssertEqual(nuanceField.value as? String, "Tell the caddie…")

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "ChatInputBar Nuance Path"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testBagButtonNeverObscuresTopMessageInLongThread() throws {
        let app = XCUIApplication()
        app.launchArguments.append("-UITestLongThread")
        app.launch()

        let conversationFeed = app.scrollViews["conversationFeed"]
        XCTAssertTrue(conversationFeed.waitForExistence(timeout: 2))

        for _ in 0..<4 {
            conversationFeed.swipeDown()
        }

        let topmostMessage = app.otherElements["topmostThreadMessage"]
        let bagButton = app.buttons["bagButton"]
        XCTAssertTrue(topmostMessage.waitForExistence(timeout: 2))
        XCTAssertTrue(bagButton.waitForExistence(timeout: 2))
        XCTAssertFalse(
            topmostMessage.frame.intersects(bagButton.frame),
            "The bag button must not overlap the topmost message at the top of a long thread."
        )
        XCTAssertGreaterThanOrEqual(
            topmostMessage.frame.minY,
            bagButton.frame.maxY,
            "The topmost message must begin below the full height reserved for the bag button."
        )

        let threadAttachment = XCTAttachment(screenshot: app.screenshot())
        threadAttachment.name = "Long Thread Clear of Bag Button"
        threadAttachment.lifetime = .keepAlways
        add(threadAttachment)

        XCTAssertTrue(bagButton.isHittable)
        bagButton.tap()
        XCTAssertTrue(app.staticTexts["Your bag"].waitForExistence(timeout: 2))

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Long Thread Bag Button Layout"
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
