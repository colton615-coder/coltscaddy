//
//  ShotHistory.swift
//  COLTSCADDY
//

import Foundation
import SwiftData

@Model
final class ShotHistory {
    @Relationship(deleteRule: .cascade)
    var context: ShotContext

    var recommendationGiven: String
    var actualClubUsed: String?
    var outcome: Outcome?
    var missDirection: String?
    var contactQuality: String?
    var cueUsed: String?
    var followedRecommendation: Bool?
    var roundID: UUID
    var loggedAt: Date

    init(
        context: ShotContext,
        recommendationGiven: String,
        actualClubUsed: String? = nil,
        outcome: Outcome? = nil,
        missDirection: String? = nil,
        contactQuality: String? = nil,
        cueUsed: String? = nil,
        followedRecommendation: Bool? = nil,
        roundID: UUID = UUID(),
        loggedAt: Date = Date()
    ) {
        self.context = context
        self.recommendationGiven = recommendationGiven
        self.actualClubUsed = actualClubUsed
        self.outcome = outcome
        self.missDirection = missDirection
        self.contactQuality = contactQuality
        self.cueUsed = cueUsed
        self.followedRecommendation = followedRecommendation
        self.roundID = roundID
        self.loggedAt = loggedAt
    }
}
