//
//  CaddyVoiceServiceTests.swift
//  COLTSCADDYTests
//

import Foundation
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

        #expect(response == "This is a stock club for you.")
    }

    @Test func usesLocalDecisionWhenBackendIsNotConfigured() async {
        let service = CaddyVoiceService(remoteRenderer: nil)

        let response = await service.response(for: testInput)

        #expect(response == "This is a stock club for you.")
    }

    @Test func backendPayloadIncludesEngineLead() throws {
        let data = try JSONEncoder().encode(CaddyVoiceRequest(input: testInput))
        let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])
        let decision = try #require(object["decision"] as? [String: Any])

        #expect(decision["lead"] as? String == "This is a stock club for you.")
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
                lead: "This is a stock club for you.",
                play: "7 Iron to 165",
                club: "7 Iron",
                distanceText: "165 yds",
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
