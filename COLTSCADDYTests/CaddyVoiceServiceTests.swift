//
//  CaddyVoiceServiceTests.swift
//  COLTSCADDYTests
//

import Testing
@testable import COLTSCADDY

struct CaddyVoiceServiceTests {
    @Test func usesBackendVoiceWhenRenderingSucceeds() async {
        let service = CaddyVoiceService(
            remoteRenderer: StubVoiceRenderer(result: .success("Take the safe number and commit to it."))
        )

        let response = await service.response(for: testInput)

        #expect(response == "Take the safe number and commit to it.")
    }

    @Test func usesLocalDecisionWhenBackendRenderingFails() async {
        let service = CaddyVoiceService(
            remoteRenderer: StubVoiceRenderer(result: .failure(.unavailable))
        )

        let response = await service.response(for: testInput)

        #expect(response.contains("7 Iron to 165."))
        #expect(response.contains("Aim center green."))
        #expect(response.contains("Confidence is medium-high."))
        #expect(response.contains("The safer alternate is 8 Iron to the front number."))
    }

    @Test func usesLocalDecisionWhenBackendIsNotConfigured() async {
        let service = CaddyVoiceService(remoteRenderer: nil)

        let response = await service.response(for: testInput)

        #expect(response.contains("7 Iron to 165."))
        #expect(response.contains("Short side is not worth chasing"))
    }

    private var testInput: CaddyVoiceInput {
        CaddyVoiceInput(
            shot: CaddyShotInput(
                shotType: .full,
                lie: .fairway,
                trouble: [],
                distanceYards: 160
            ),
            decision: CaddyDecision(
                play: "7 Iron to 165",
                target: "Aim center green.",
                safeMiss: "Short side is not worth chasing; take the middle.",
                why: "The clean lie allows the safe bag number.",
                confidence: .mediumHigh,
                alternate: .init(type: "safer", text: "8 Iron to the front number.")
            )
        )
    }
}

private struct StubVoiceRenderer: CaddyVoiceRendering {
    let result: Result<String, StubVoiceError>

    func render(_ input: CaddyVoiceInput) async throws -> String {
        try result.get()
    }
}

private enum StubVoiceError: Error {
    case unavailable
}
