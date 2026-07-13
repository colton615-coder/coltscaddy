//
//  CoachingCue.swift
//  COLTSCADDY
//

import Foundation
import SwiftData

@Model
final class CoachingCue {
    var text: String
    var club: String?
    var shotType: ShotType?
    var distanceBand: String?
    var lie: Lie?
    var validated: Bool
    var createdAt: Date

    init(
        text: String,
        club: String? = nil,
        shotType: ShotType? = nil,
        distanceBand: String? = nil,
        lie: Lie? = nil,
        validated: Bool = false,
        createdAt: Date = Date()
    ) {
        self.text = text
        self.club = club
        self.shotType = shotType
        self.distanceBand = distanceBand
        self.lie = lie
        self.validated = validated
        self.createdAt = createdAt
    }
}
