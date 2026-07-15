//
//  ProfileSeeder.swift
//  COLTSCADDY
//

import Foundation
import SwiftData

enum ProfileSeeder {
    /// Placeholder carry distances. Colt corrects these once in the bag editor;
    /// they are never overwritten after the first launch.
    static let defaultBag: [(name: String, carryYards: Int)] = [
        ("Driver", 230),
        ("3 Wood", 215),
        ("3 Hybrid", 200),
        ("5 Iron", 185),
        ("6 Iron", 175),
        ("7 Iron", 165),
        ("8 Iron", 155),
        ("9 Iron", 145),
        ("Pitching Wedge", 130),
        ("Gap Wedge", 115),
        ("Sand Wedge", 100),
        ("Lob Wedge", 80)
    ]

    /// Canonical longest-to-shortest club order, used to keep the bag editor
    /// rows stable while carry numbers are being edited.
    static let bagOrder: [String] = defaultBag.map(\.name)

    /// Returns the existing profile, or creates and saves one seeded with the
    /// default bag when the store is empty.
    @discardableResult
    static func seedIfNeeded(in context: ModelContext) throws -> PlayerProfile {
        var descriptor = FetchDescriptor<PlayerProfile>()
        descriptor.fetchLimit = 1

        if let existing = try context.fetch(descriptor).first {
            return existing
        }

        let clubs = defaultBag.map { ClubDistance(clubName: $0.name, carryYards: $0.carryYards) }
        let profile = PlayerProfile(clubDistances: clubs)
        context.insert(profile)
        try context.save()

        return profile
    }
}
