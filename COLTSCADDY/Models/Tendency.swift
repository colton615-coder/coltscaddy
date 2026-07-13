//
//  Tendency.swift
//  COLTSCADDY
//

import Foundation
import SwiftData

@Model
final class Tendency {
    var descriptionText: String
    var insightType: InsightType
    var confidence: ConfidenceBand
    var sampleSize: Int
    var confirmedByUser: Bool
    var lastUpdated: Date

    init(
        descriptionText: String,
        insightType: InsightType,
        confidence: ConfidenceBand,
        sampleSize: Int,
        confirmedByUser: Bool = false,
        lastUpdated: Date = Date()
    ) {
        self.descriptionText = descriptionText
        self.insightType = insightType
        self.confidence = confidence
        self.sampleSize = sampleSize
        self.confirmedByUser = confirmedByUser
        self.lastUpdated = lastUpdated
    }
}
