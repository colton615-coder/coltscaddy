//
//  CaddyEngineTests.swift
//  COLTSCADDYTests
//

import Testing
@testable import COLTSCADDY

struct CaddyEngineTests {
    @Test func teeShotWithPenaltyTroubleChoosesInPlayClubInsteadOfDriver() {
        let decision = CaddyEngine.recommend(
            for: CaddyShotInput(shotType: .tee, lie: .tee, trouble: [.water], distanceYards: 420),
            bag: testBag
        )

        #expect(decision.play.contains("3 Hybrid"))
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
        #expect(decision.alternate.text.contains("8 Iron"))
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

    private var testBag: [CaddyBagClub] {
        ProfileSeeder.defaultBag.map {
            CaddyBagClub(name: $0.name, carryYards: $0.carryYards)
        }
    }
}
