//
//  PlayerProfile.swift
//  COLTSCADDY
//

import Foundation
import SwiftData

@Model
final class ClubDistance {
    var clubName: String
    var carryYards: Int

    init(clubName: String, carryYards: Int) {
        self.clubName = clubName
        self.carryYards = carryYards
    }
}

@Model
final class PlayerProfile {
    @Relationship(deleteRule: .cascade)
    var clubDistances: [ClubDistance]

    var preferredShapes: [String]

    @Relationship(deleteRule: .cascade)
    var confirmedTendencies: [Tendency]

    @Relationship(deleteRule: .cascade)
    var validatedCues: [CoachingCue]

    init(
        clubDistances: [ClubDistance] = [],
        preferredShapes: [String] = [],
        confirmedTendencies: [Tendency] = [],
        validatedCues: [CoachingCue] = []
    ) {
        self.clubDistances = clubDistances
        self.preferredShapes = preferredShapes
        self.confirmedTendencies = confirmedTendencies
        self.validatedCues = validatedCues
    }
}
