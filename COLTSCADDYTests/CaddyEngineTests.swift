//
//  CaddyEngineTests.swift
//  COLTSCADDYTests
//

import Testing
@testable import COLTSCADDY

struct CaddyEngineTests {
    @Test func everyShotTypeHasASafeExecutionTip() {
        for shotType in ShotType.allCases {
            let tip = CaddyEngine.executionTip(for: shotType)
            let normalizedTip = tip.lowercased()

            #expect(tip.contains(where: { !$0.isWhitespace }))
            #expect(!normalizedTip.contains("wind"))
            #expect(!normalizedTip.contains("plays like"))
        }
    }

    @Test func teeShotWithPenaltyTroubleChoosesInPlayClubInsteadOfDriver() {
        let decision = CaddyEngine.recommend(
            for: CaddyShotInput(shotType: .tee, lie: .tee, trouble: [.water], distanceYards: 420),
            bag: testBag
        )

        #expect(decision.play.contains("3 Hybrid"))
        #expect(decision.club == "3 Hybrid")
        #expect(decision.distanceText == "200 yds")
        #expect(!decision.play.contains("Driver"))
        #expect(decision.safeMiss.contains("water"))
        #expect(decision.confidence == .mediumHigh)
    }

    @Test func teeShotWithoutTroubleAllowsDriver() {
        let decision = CaddyEngine.recommend(
            for: CaddyShotInput(shotType: .tee, lie: .tee, trouble: [.none], distanceYards: 420),
            bag: testBag
        )

        #expect(decision.play.contains("Driver"))
        #expect(decision.confidence == .high)
    }

    @Test func shortCleanChipDefaultsToPutter() {
        let decision = CaddyEngine.recommend(
            for: CaddyShotInput(shotType: .chip, lie: .fairway, trouble: [.none], distanceYards: 8),
            bag: testBag
        )

        #expect(decision.play.contains("Putter"))
        #expect(decision.why.contains("lowest-loft"))
    }

    @Test func chipDefaultsToBumpAndRunBeforeLobWedge() {
        let decision = CaddyEngine.recommend(
            for: CaddyShotInput(shotType: .chip, lie: .rough, trouble: [.none], distanceYards: 22),
            bag: testBag
        )

        #expect(decision.play.contains("8 Iron"))
        #expect(!decision.play.contains("Lob Wedge"))
        #expect(decision.alternate.text.contains("Lob Wedge"))
    }

    @Test func troubleRecoveryAdvancesToWedgeNumber() {
        let decision = CaddyEngine.recommend(
            for: CaddyShotInput(shotType: .full, lie: .rough, trouble: [.trees], distanceYards: 175),
            bag: testBag
        )

        #expect(decision.play.contains("Sand Wedge"))
        #expect(decision.play.contains("100"))
        #expect(decision.why.contains("full-wedge number"))
        #expect(decision.confidence == .medium)
    }

    @Test func cleanFullShotRoundsTowardEnoughClub() {
        let decision = CaddyEngine.recommend(
            for: CaddyShotInput(shotType: .full, lie: .fairway, trouble: [.none], distanceYards: 160),
            bag: testBag
        )

        #expect(decision.play.contains("7 Iron"))
        #expect(decision.play.contains("165"))
        #expect(decision.club == "7 Iron")
        #expect(decision.distanceText == "165 yds")
        #expect(decision.target == "Center green.")
        #expect(decision.safeMiss == "Short is fine.")
        #expect(decision.why == "Stock number. No need to force it.")
        #expect(decision.alternate.text.contains("8 Iron"))
        #expect(CaddyEngine.executionTip(for: .full) == "SET THE FACE  •  SET YOUR FEET  •  COMMIT")
    }

    @Test func invalidDistanceStillProducesLowConfidenceCall() {
        let decision = CaddyEngine.recommend(
            for: CaddyShotInput(shotType: .full, lie: .fairway, trouble: [.none], distanceYards: 0),
            bag: testBag
        )

        #expect(decision.confidence == .low)
        #expect(!decision.play.isEmpty)
        #expect(!decision.alternate.text.isEmpty)
    }

    @Test func everyDecisionBranchProducesItsSpecificShortLead() {
        let cases: [(input: CaddyShotInput, expectedLead: String)] = [
            (
                CaddyShotInput(shotType: .tee, lie: .tee, trouble: [.water], distanceYards: 420),
                "Driver stays in the bag here."
            ),
            (
                CaddyShotInput(shotType: .tee, lie: .tee, trouble: [.none], distanceYards: 420),
                "Driver gets the green light."
            ),
            (
                CaddyShotInput(shotType: .chip, lie: .sand, trouble: [.none], distanceYards: 18),
                "Get it out cleanly and move on."
            ),
            (
                CaddyShotInput(shotType: .chip, lie: .fairway, trouble: [.none], distanceYards: 8),
                "The putter is the smart, boring play."
            ),
            (
                CaddyShotInput(shotType: .chip, lie: .rough, trouble: [.none], distanceYards: 22),
                "Keep this one low and predictable."
            ),
            (
                CaddyShotInput(shotType: .putt, lie: .fairway, trouble: [.none], distanceYards: 20),
                "Match the speed and trust it."
            ),
            (
                CaddyShotInput(shotType: .full, lie: .rough, trouble: [.trees], distanceYards: 175),
                "Advance it to a number instead of playing hero."
            ),
            (
                CaddyShotInput(shotType: .full, lie: .fairway, trouble: [.none], distanceYards: 160),
                "This is a stock club for you."
            ),
            (
                CaddyShotInput(shotType: .full, lie: .fairway, trouble: [.none], distanceYards: 0),
                "The number is missing, but the safe call still stands."
            )
        ]

        for testCase in cases {
            let decision = CaddyEngine.recommend(for: testCase.input, bag: testBag)

            #expect(decision.lead == testCase.expectedLead)
            #expect(decision.lead.split(separator: " ").count <= 12)
            #expect(".!?".contains(decision.lead.last ?? " "))
        }
    }

    private var testBag: [CaddyBagClub] {
        ProfileSeeder.defaultBag.map {
            CaddyBagClub(name: $0.name, carryYards: $0.carryYards)
        }
    }
}
