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
    func testCompactCaddyCallMatchesApprovedCommandFirstState() throws {
        let app = XCUIApplication()
        app.launchArguments.append("-UITestCompactCaddyCall")
        app.launch()

        XCTAssertTrue(app.staticTexts["CADDY CALL"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["3 Hybrid"].exists)
        XCTAssertTrue(app.staticTexts["200 yds"].exists)
        XCTAssertEqual(app.staticTexts["targetCommand"].label, "Aim at the widest fairway")
        XCTAssertEqual(app.staticTexts["safeMissValue"].label, "Away from OB. Stay in bounds.")
        XCTAssertTrue(app.buttons["Alternate play"].isHittable)
        XCTAssertTrue(app.buttons["Remind me how"].isHittable)
        XCTAssertTrue(app.buttons["Log result"].isHittable)

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Approved Compact Command-First Caddy Call"
        attachment.lifetime = .keepAlways
        add(attachment)
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

        XCTAssertTrue(app.staticTexts["CADDY CALL"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["This is a stock club for you."].exists)
        XCTAssertTrue(app.staticTexts["7 Iron"].exists)
        XCTAssertTrue(app.staticTexts["165 yds"].exists)
        XCTAssertFalse(app.staticTexts["Medium-high"].exists)
        let targetCommand = app.staticTexts["targetCommand"]
        let safeMissValue = app.staticTexts["safeMissValue"]
        let whyValue = app.staticTexts["whyValue"]
        XCTAssertEqual(targetCommand.label, "Aim at center green")
        XCTAssertEqual(safeMissValue.label, "Short is fine.")
        XCTAssertEqual(whyValue.label, "Stock number. No need to force it.")

        let collapsedCardAttachment = XCTAttachment(screenshot: app.screenshot())
        collapsedCardAttachment.name = "Compact Caddy Call Collapsed"
        collapsedCardAttachment.lifetime = .keepAlways
        add(collapsedCardAttachment)

        let alternateButton = app.buttons["Alternate play"]
        let alternatePlay = app.staticTexts["8 Iron to the front number."]
        XCTAssertTrue(alternateButton.exists)
        XCTAssertFalse(alternatePlay.exists)
        alternateButton.tap()
        XCTAssertTrue(alternatePlay.waitForExistence(timeout: 2))
        alternateButton.tap()
        XCTAssertFalse(alternatePlay.exists)

        let executionTip = app.staticTexts[
            "SET THE FACE  •  SET YOUR FEET  •  COMMIT"
        ]
        let remindButton = app.buttons["Remind me how"]
        XCTAssertTrue(remindButton.exists)
        XCTAssertFalse(executionTip.exists)

        remindButton.tap()

        XCTAssertTrue(executionTip.waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["COMMIT TO THIS"].exists)

        let logResultButton = app.buttons["Log result"]
        XCTAssertTrue(logResultButton.exists)
        XCTAssertTrue(logResultButton.isHittable)
        XCTAssertTrue(logResultButton.isEnabled)

        let hideReminderButton = app.buttons["Hide reminder"]
        XCTAssertTrue(hideReminderButton.waitForExistence(timeout: 2))
        XCTAssertTrue(hideReminderButton.isHittable)

        let expandedTipAttachment = XCTAttachment(screenshot: app.screenshot())
        expandedTipAttachment.name = "Expanded Full-Shot Execution Tip"
        expandedTipAttachment.lifetime = .keepAlways
        add(expandedTipAttachment)

        hideReminderButton.tap()
        XCTAssertFalse(executionTip.exists)

        logResultButton.tap()

        XCTAssertTrue(app.otherElements["outcomePicker"].waitForExistence(timeout: 2))
        for outcome in ["Good", "Left", "Right", "Short", "Long", "Poor contact"] {
            XCTAssertTrue(app.buttons["outcome-\(outcome == "Poor contact" ? "poorContact" : outcome.lowercased())"].exists)
        }

        app.buttons["outcomeCancelButton"].tap()
        XCTAssertTrue(logResultButton.waitForExistence(timeout: 2))
        XCTAssertTrue(logResultButton.isEnabled)

        logResultButton.tap()
        XCTAssertTrue(app.buttons["outcome-good"].waitForExistence(timeout: 2))
        app.buttons["outcome-good"].tap()

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
