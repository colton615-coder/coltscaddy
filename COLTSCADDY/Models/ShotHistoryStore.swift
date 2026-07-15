//
//  ShotHistoryStore.swift
//  COLTSCADDY
//

import SwiftData

enum ShotHistoryStore {
    @discardableResult
    static func log(
        shot: CaddyShotInput,
        decision: CaddyDecision,
        in modelContext: ModelContext
    ) throws -> ShotHistory {
        let shotContext = ShotContext(
            shotType: shot.shotType,
            lie: shot.lie,
            trouble: shot.trouble,
            distanceYards: shot.distanceYards,
            nuance: shot.nuance
        )
        let history = ShotHistory(
            context: shotContext,
            recommendationGiven: decision.play
        )

        modelContext.insert(history)
        try modelContext.save()

        return history
    }
}
