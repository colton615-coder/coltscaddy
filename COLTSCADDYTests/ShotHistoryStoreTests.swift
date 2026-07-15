//
//  ShotHistoryStoreTests.swift
//  COLTSCADDYTests
//

import Testing
import SwiftData
@testable import COLTSCADDY

struct ShotHistoryStoreTests {
    private func makeContext() throws -> ModelContext {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: ShotContext.self,
            ShotHistory.self,
            configurations: configuration
        )
        return ModelContext(container)
    }

    @Test func logsOneHistoryWithTheCorrectContextAndRecommendation() throws {
        let modelContext = try makeContext()
        let shot = CaddyShotInput(
            shotType: .full,
            lie: .rough,
            trouble: [.trees],
            distanceYards: 175,
            nuance: "Branches block the direct line."
        )
        let decision = CaddyEngine.recommend(
            for: shot,
            bag: ProfileSeeder.defaultBag.map {
                CaddyBagClub(name: $0.name, carryYards: $0.carryYards)
            }
        )

        let loggedHistory = try ShotHistoryStore.log(
            shot: shot,
            decision: decision,
            in: modelContext
        )

        let histories = try modelContext.fetch(FetchDescriptor<ShotHistory>())
        let storedHistory = try #require(histories.first)

        #expect(histories.count == 1)
        #expect(storedHistory.persistentModelID == loggedHistory.persistentModelID)
        #expect(storedHistory.context.shotType == shot.shotType)
        #expect(storedHistory.context.lie == shot.lie)
        #expect(storedHistory.context.trouble == shot.trouble)
        #expect(storedHistory.context.distanceYards == shot.distanceYards)
        #expect(storedHistory.context.nuance == shot.nuance)
        #expect(storedHistory.recommendationGiven == decision.play)
        #expect(storedHistory.outcome == nil)
        #expect(storedHistory.missDirection == nil)
        #expect(storedHistory.contactQuality == nil)
        #expect(storedHistory.followedRecommendation == nil)
    }
}
