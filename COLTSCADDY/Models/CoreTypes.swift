//
//  CoreTypes.swift
//  COLTSCADDY
//

import Foundation

enum ShotType: String, Codable, CaseIterable {
    case full
    case chip
    case putt
    case tee
}

enum Lie: String, Codable, CaseIterable {
    case tee
    case fairway
    case rough
    case sand
}

enum Trouble: String, Codable, CaseIterable {
    case water
    case ob
    case trees
    case bunker
    case none
}

enum Outcome: String, Codable, CaseIterable {
    case good
    case left
    case right
    case short
    case long
    case poorContact

    var displayName: String {
        switch self {
        case .good:
            "Good"
        case .left:
            "Left"
        case .right:
            "Right"
        case .short:
            "Short"
        case .long:
            "Long"
        case .poorContact:
            "Poor contact"
        }
    }
}

enum InsightType: String, Codable, CaseIterable {
    case fact
    case result
    case inference
    case confirmedTendency
    case cue
    case confidence
}

enum ConfidenceBand: String, Codable, CaseIterable {
    case low
    case medium
    case mediumHigh
    case high
}
