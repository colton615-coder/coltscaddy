//
//  CaddyEngine.swift
//  COLTSCADDY
//

import Foundation

struct CaddyDecision: Equatable {
    struct Alternate: Equatable {
        let type: String
        let text: String
    }

    let play: String
    let club: String
    let distanceText: String
    let target: String
    let safeMiss: String
    let why: String
    let confidence: ConfidenceBand
    let alternate: Alternate
}

struct CaddyShotInput: Equatable {
    let shotType: ShotType
    let lie: Lie
    let trouble: [Trouble]
    let distanceYards: Int
    let nuance: String?

    init(
        shotType: ShotType,
        lie: Lie,
        trouble: [Trouble],
        distanceYards: Int,
        nuance: String? = nil
    ) {
        self.shotType = shotType
        self.lie = lie
        self.trouble = trouble
        self.distanceYards = distanceYards
        self.nuance = nuance
    }
}

struct CaddyBagClub: Equatable {
    let name: String
    let carryYards: Int
}

enum CaddyEngine {
    static func recommend(for context: ShotContext, profile: PlayerProfile) -> CaddyDecision {
        let input = CaddyShotInput(
            shotType: context.shotType,
            lie: context.lie,
            trouble: context.trouble,
            distanceYards: context.distanceYards,
            nuance: context.nuance
        )
        let bag = profile.clubDistances.map {
            CaddyBagClub(name: $0.clubName, carryYards: $0.carryYards)
        }

        return recommend(for: input, bag: bag)
    }

    static func recommend(for input: CaddyShotInput, bag: [CaddyBagClub]) -> CaddyDecision {
        let bag = orderedBag(from: bag)
        let trouble = normalizedTrouble(input.trouble)

        guard input.distanceYards > 0 else {
            return invalidDistanceDecision()
        }

        switch input.shotType {
        case .tee:
            return teeDecision(for: input, bag: bag, trouble: trouble)
        case .chip:
            return chipDecision(for: input, bag: bag, trouble: trouble)
        case .putt:
            return puttDecision(for: input)
        case .full:
            return fullShotDecision(for: input, bag: bag, trouble: trouble)
        }
    }
}

private extension CaddyEngine {
    static func teeDecision(
        for input: CaddyShotInput,
        bag: [CaddyBagClub],
        trouble: Set<Trouble>
    ) -> CaddyDecision {
        if containsPenaltyTrouble(trouble) {
            let club = safeTeeClub(from: bag)
            let alternate = longestNonDriver(from: bag) ?? club

            return CaddyDecision(
                play: "\(club.name) to \(club.carryYards)",
                club: club.name,
                distanceText: distanceText(for: club.carryYards),
                target: "Aim at the widest part of the fairway.",
                safeMiss: safeMiss(for: trouble, fallback: "Short grass beats extra yards here."),
                why: "Penalty trouble is marked on a tee shot, so the call is the most in-play club instead of driver.",
                confidence: .mediumHigh,
                alternate: .init(
                    type: "aggressive",
                    text: "\(alternate.name) only if that still keeps the penalty out of play."
                )
            )
        }

        let club = driver(from: bag) ?? longestClub(from: bag)

        return CaddyDecision(
            play: "\(club.name) to \(club.carryYards)",
            club: club.name,
            distanceText: distanceText(for: club.carryYards),
            target: "Favor the center of the landing area.",
            safeMiss: "Either side is playable; make a committed swing.",
            why: "No penalty trouble is marked, so driver is allowed.",
            confidence: .high,
            alternate: .init(type: "safer", text: "\(safeTeeClub(from: bag).name) if the landing area looks tighter than entered.")
        )
    }

    static func chipDecision(
        for input: CaddyShotInput,
        bag: [CaddyBagClub],
        trouble: Set<Trouble>
    ) -> CaddyDecision {
        if input.lie == .sand || trouble.contains(.bunker) {
            let club = namedClub(containing: "Sand Wedge", in: bag) ?? highestLoftWedge(from: bag)

            return CaddyDecision(
                play: "\(club.name), splash it on",
                club: club.name,
                distanceText: distanceText(for: input.distanceYards),
                target: "Land it safely on the green.",
                safeMiss: "Long is better than leaving it in the bunker.",
                why: "Sand takes putter and bump-and-run out of the default plan.",
                confidence: .medium,
                alternate: .init(type: "safer", text: "Take enough sand and guarantee the ball exits.")
            )
        }

        if input.distanceYards <= 12 && input.lie == .fairway && trouble.isEmpty {
            return CaddyDecision(
                play: "Putter from off the green",
                club: "Putter",
                distanceText: distanceText(for: input.distanceYards),
                target: "Roll it on your start line.",
                safeMiss: "Past the hole is fine; do not stub it short.",
                why: "For short chips, the lowest-loft option that works is the default.",
                confidence: .high,
                alternate: .init(type: "middle", text: "Bump-and-run with \(bumpAndRunClub(from: bag).name) if the fringe is too uneven.")
            )
        }

        let club = bumpAndRunClub(from: bag)

        return CaddyDecision(
            play: "\(club.name) bump-and-run",
            club: club.name,
            distanceText: distanceText(for: input.distanceYards),
            target: "Land it early and let it roll.",
            safeMiss: "Leave the next one uphill if you miss.",
            why: "The chip rule favors low loft first. The 60-degree is not the default.",
            confidence: .mediumHigh,
            alternate: .init(type: "lofted", text: "\(highestLoftWedge(from: bag).name) only when you must carry something.")
        )
    }

    static func puttDecision(for input: CaddyShotInput) -> CaddyDecision {
        CaddyDecision(
            play: "Putter",
            club: "Putter",
            distanceText: distanceText(for: input.distanceYards),
            target: "Start it on your intended line.",
            safeMiss: "Speed first; leave a simple comeback.",
            why: "This is a putt, so the caddie commits to the putter.",
            confidence: input.distanceYards > 0 ? .high : .low,
            alternate: .init(type: "lag", text: "Die it near the hole if make pace brings three-putt risk.")
        )
    }

    static func fullShotDecision(
        for input: CaddyShotInput,
        bag: [CaddyBagClub],
        trouble: Set<Trouble>
    ) -> CaddyDecision {
        if input.lie == .rough || input.lie == .sand || !trouble.isEmpty {
            let bailout = wedgeBailoutClub(from: bag)

            return CaddyDecision(
                play: "Advance it to \(bailout.carryYards) with \(bailout.name)",
                club: bailout.name,
                distanceText: distanceText(for: bailout.carryYards),
                target: "Pick the cleanest fairway number.",
                safeMiss: safeMiss(for: trouble, fallback: "Short and in play is the win."),
                why: "Bad lies and marked trouble are where hero recoveries make big numbers. A full-wedge number is the win.",
                confidence: .medium,
                alternate: .init(type: "safer", text: "Punch out sideways if the line is blocked.")
            )
        }

        let club = fullSwingClub(for: input.distanceYards, from: bag, avoidLong: trouble.contains(.bunker))

        return CaddyDecision(
            play: "\(club.name) to \(club.carryYards)",
            club: club.name,
            distanceText: distanceText(for: club.carryYards),
            target: "Aim center green.",
            safeMiss: "Short side is not worth chasing; take the middle.",
            why: "Clean lie with no marked trouble, so the call is the bag number rounded toward safety.",
            confidence: .mediumHigh,
            alternate: .init(type: "safer", text: "\(shorterClub(than: club, in: bag)?.name ?? club.name) to the front number.")
        )
    }
}

private extension CaddyEngine {
    static func orderedBag(from bag: [CaddyBagClub]) -> [CaddyBagClub] {
        bag.sorted { first, second in
            if first.carryYards == second.carryYards {
                return first.name < second.name
            }

            return first.carryYards > second.carryYards
        }
    }

    static func normalizedTrouble(_ trouble: [Trouble]) -> Set<Trouble> {
        Set(trouble.filter { $0 != .none })
    }

    static func containsPenaltyTrouble(_ trouble: Set<Trouble>) -> Bool {
        trouble.contains(.water) || trouble.contains(.ob) || trouble.contains(.trees)
    }

    static func fullSwingClub(for distance: Int, from bag: [CaddyBagClub], avoidLong: Bool) -> CaddyBagClub {
        if avoidLong, let safeClub = bag.first(where: { $0.carryYards <= distance }) {
            return safeClub
        }

        if let enoughClub = bag.reversed().first(where: { $0.carryYards >= distance }) {
            return enoughClub
        }

        return longestClub(from: bag)
    }

    static func safeTeeClub(from bag: [CaddyBagClub]) -> CaddyBagClub {
        let preferredNames = ["Hybrid", "5 Iron", "4 Iron", "6 Iron", "3 Wood", "7 Iron"]

        for name in preferredNames {
            if let club = namedClub(containing: name, in: bag) {
                return club
            }
        }

        return longestNonDriver(from: bag) ?? longestClub(from: bag)
    }

    static func bumpAndRunClub(from bag: [CaddyBagClub]) -> CaddyBagClub {
        namedClub(containing: "8 Iron", in: bag)
            ?? namedClub(containing: "9 Iron", in: bag)
            ?? shortestNonWedge(from: bag)
            ?? wedgeBailoutClub(from: bag)
    }

    static func wedgeBailoutClub(from bag: [CaddyBagClub]) -> CaddyBagClub {
        let wedges = bag.filter { $0.name.localizedCaseInsensitiveContains("Wedge") }

        return wedges.min { first, second in
            abs(first.carryYards - 100) < abs(second.carryYards - 100)
        } ?? shortestClub(from: bag)
    }

    static func highestLoftWedge(from bag: [CaddyBagClub]) -> CaddyBagClub {
        let wedges = bag.filter { $0.name.localizedCaseInsensitiveContains("Wedge") }
        return wedges.min { $0.carryYards < $1.carryYards } ?? shortestClub(from: bag)
    }

    static func driver(from bag: [CaddyBagClub]) -> CaddyBagClub? {
        namedClub(containing: "Driver", in: bag)
    }

    static func longestNonDriver(from bag: [CaddyBagClub]) -> CaddyBagClub? {
        bag.first { !$0.name.localizedCaseInsensitiveContains("Driver") }
    }

    static func shortestNonWedge(from bag: [CaddyBagClub]) -> CaddyBagClub? {
        bag.reversed().first { !$0.name.localizedCaseInsensitiveContains("Wedge") }
    }

    static func longestClub(from bag: [CaddyBagClub]) -> CaddyBagClub {
        bag.first ?? fallbackClub
    }

    static func shortestClub(from bag: [CaddyBagClub]) -> CaddyBagClub {
        bag.last ?? fallbackClub
    }

    static func shorterClub(than club: CaddyBagClub, in bag: [CaddyBagClub]) -> CaddyBagClub? {
        guard let index = bag.firstIndex(of: club) else { return nil }
        let nextIndex = bag.index(after: index)

        guard bag.indices.contains(nextIndex) else { return nil }
        return bag[nextIndex]
    }

    static func namedClub(containing name: String, in bag: [CaddyBagClub]) -> CaddyBagClub? {
        bag.first { $0.name.localizedCaseInsensitiveContains(name) }
    }

    static func safeMiss(for trouble: Set<Trouble>, fallback: String) -> String {
        if trouble.contains(.water) {
            return "Miss away from the water, even if that means short."
        }

        if trouble.contains(.ob) {
            return "Miss away from OB. In bounds is the whole job."
        }

        if trouble.contains(.trees) {
            return "Miss where the next swing is clear of the trees."
        }

        if trouble.contains(.bunker) {
            return "Favor short of the bunker."
        }

        return fallback
    }

    static func invalidDistanceDecision() -> CaddyDecision {
        CaddyDecision(
            play: "Take the safest playable club",
            club: "Take the safest playable club",
            distanceText: distanceText(for: 0),
            target: "Choose the largest safe target.",
            safeMiss: "Keep it in play.",
            why: "The distance is missing or invalid, so confidence drops but the caddie still commits.",
            confidence: .low,
            alternate: .init(type: "reset", text: "Advance to a comfortable wedge number.")
        )
    }

    static var fallbackClub: CaddyBagClub {
        CaddyBagClub(name: "Safe club", carryYards: 0)
    }

    static func distanceText(for yards: Int) -> String {
        "\(yards) yds"
    }
}
