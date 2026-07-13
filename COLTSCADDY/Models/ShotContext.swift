//
//  ShotContext.swift
//  COLTSCADDY
//

import Foundation
import SwiftData

@Model
final class ShotContext {
    var shotType: ShotType
    var lie: Lie
    var trouble: [Trouble]
    var distanceYards: Int
    var nuance: String?
    var createdAt: Date

    init(
        shotType: ShotType,
        lie: Lie,
        trouble: [Trouble],
        distanceYards: Int,
        nuance: String? = nil,
        createdAt: Date = Date()
    ) {
        self.shotType = shotType
        self.lie = lie
        self.trouble = trouble
        self.distanceYards = distanceYards
        self.nuance = nuance
        self.createdAt = createdAt
    }
}
