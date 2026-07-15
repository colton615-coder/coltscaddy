//
//  ProfileSeederTests.swift
//  COLTSCADDYTests
//

import Testing
import SwiftData
@testable import COLTSCADDY

struct ProfileSeederTests {
    private func makeContext() throws -> ModelContext {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: PlayerProfile.self,
            ClubDistance.self,
            Tendency.self,
            CoachingCue.self,
            configurations: configuration
        )
        return ModelContext(container)
    }

    @Test func seedsProfileWithDefaultBagOnFirstRun() throws {
        let context = try makeContext()

        let profile = try ProfileSeeder.seedIfNeeded(in: context)

        #expect(profile.clubDistances.count == ProfileSeeder.defaultBag.count)

        let seededNames = Set(profile.clubDistances.map(\.clubName))
        #expect(seededNames == Set(ProfileSeeder.bagOrder))
    }

    @Test func doesNotDuplicateProfileOnSecondRun() throws {
        let context = try makeContext()

        let first = try ProfileSeeder.seedIfNeeded(in: context)
        let second = try ProfileSeeder.seedIfNeeded(in: context)

        #expect(first.persistentModelID == second.persistentModelID)

        let profiles = try context.fetch(FetchDescriptor<PlayerProfile>())
        #expect(profiles.count == 1)
    }

    @Test func doesNotOverwriteEditedDistances() throws {
        let context = try makeContext()

        let profile = try ProfileSeeder.seedIfNeeded(in: context)
        let driver = try #require(profile.clubDistances.first { $0.clubName == "Driver" })
        driver.carryYards = 262
        try context.save()

        try ProfileSeeder.seedIfNeeded(in: context)

        let reloaded = try context.fetch(FetchDescriptor<PlayerProfile>())
        let reloadedDriver = try #require(
            reloaded.first?.clubDistances.first { $0.clubName == "Driver" }
        )
        #expect(reloadedDriver.carryYards == 262)
    }

    @Test func defaultBagIsOrderedLongestToShortestWithUniqueNames() {
        let names = ProfileSeeder.defaultBag.map(\.name)
        #expect(Set(names).count == names.count)

        let carries = ProfileSeeder.defaultBag.map(\.carryYards)
        #expect(carries == carries.sorted(by: >))
        #expect(carries.allSatisfy { $0 > 0 })
    }
}
