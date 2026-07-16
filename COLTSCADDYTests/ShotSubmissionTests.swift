//
//  ShotSubmissionTests.swift
//  COLTSCADDYTests
//

import Testing
@testable import COLTSCADDY

struct ShotSubmissionTests {
    @Test func attachesTrimmedNuanceToTheNextShotAndVisibleSummary() {
        let submission = baseSubmission.attachingNuance("  Ball below my feet.  ")

        #expect(submission.input.nuance == "Ball below my feet.")
        #expect(submission.summary.contains("Nuance: Ball below my feet."))
    }

    @Test func whitespaceOnlyNuanceBecomesNilAndLeavesTheSummaryUnchanged() {
        let submission = baseSubmission.attachingNuance("  \n  ")

        #expect(submission.input.nuance == nil)
        #expect(submission.summary == baseSubmission.summary)
    }

    private var baseSubmission: ShotSubmission {
        ShotSubmission(
            input: CaddyShotInput(
                shotType: .full,
                lie: .fairway,
                trouble: [],
                distanceYards: 165
            ),
            summary: "165 yards, fairway, full shot, no trouble marked."
        )
    }
}
