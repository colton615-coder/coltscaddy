//
//  CaddyVoiceService.swift
//  COLTSCADDY
//

import Foundation

struct CaddyVoiceInput: Equatable {
    let shot: CaddyShotInput
    let decision: CaddyDecision
}

protocol CaddyVoiceRendering {
    func render(_ input: CaddyVoiceInput) async throws -> String
}

struct CaddyVoiceService {
    private let remoteRenderer: (any CaddyVoiceRendering)?

    init(remoteRenderer: (any CaddyVoiceRendering)?) {
        self.remoteRenderer = remoteRenderer
    }

    static var live: CaddyVoiceService {
        let remoteRenderer = CaddyVoiceConfiguration.backendEndpoint.map {
            HTTPBackendCaddyVoiceRenderer(endpoint: $0)
        }

        return CaddyVoiceService(remoteRenderer: remoteRenderer)
    }

    func response(for input: CaddyVoiceInput) async -> String {
        guard let remoteRenderer else {
            return LocalCaddyVoiceRenderer.render(input)
        }

        do {
            let renderedText = try await remoteRenderer.render(input)
                .trimmingCharacters(in: .whitespacesAndNewlines)

            guard !renderedText.isEmpty else {
                return LocalCaddyVoiceRenderer.render(input)
            }

            return renderedText
        } catch {
            return LocalCaddyVoiceRenderer.render(input)
        }
    }
}

struct HTTPBackendCaddyVoiceRenderer: CaddyVoiceRendering {
    let endpoint: URL
    var session: URLSession = .shared

    func render(_ input: CaddyVoiceInput) async throws -> String {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.timeoutInterval = 8
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONEncoder().encode(CaddyVoiceRequest(input: input))

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw CaddyVoiceError.invalidResponse
        }

        let responseBody = try JSONDecoder().decode(CaddyVoiceResponse.self, from: data)
        return responseBody.assistantText
    }
}

private enum CaddyVoiceConfiguration {
    static var backendEndpoint: URL? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "CADDY_VOICE_ENDPOINT") as? String else {
            return nil
        }

        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedValue.isEmpty else { return nil }

        return URL(string: trimmedValue)
    }
}

private enum CaddyVoiceError: Error {
    case invalidResponse
}

private struct CaddyVoiceRequest: Encodable {
    struct Shot: Encodable {
        let shotType: String
        let lie: String
        let trouble: [String]
        let distanceYards: Int
        let nuance: String?
    }

    struct Decision: Encodable {
        struct Alternate: Encodable {
            let type: String
            let text: String
        }

        let play: String
        let club: String
        let distanceText: String
        let target: String
        let safeMiss: String
        let why: String
        let confidence: String
        let alternate: Alternate
    }

    let shot: Shot
    let decision: Decision

    init(input: CaddyVoiceInput) {
        shot = Shot(
            shotType: input.shot.shotType.rawValue,
            lie: input.shot.lie.rawValue,
            trouble: input.shot.trouble.filter { $0 != .none }.map(\.rawValue).sorted(),
            distanceYards: input.shot.distanceYards,
            nuance: input.shot.nuance
        )
        decision = Decision(
            play: input.decision.play,
            club: input.decision.club,
            distanceText: input.decision.distanceText,
            target: input.decision.target,
            safeMiss: input.decision.safeMiss,
            why: input.decision.why,
            confidence: input.decision.confidence.rawValue,
            alternate: .init(
                type: input.decision.alternate.type,
                text: input.decision.alternate.text
            )
        )
    }
}

private struct CaddyVoiceResponse: Decodable {
    let assistantText: String
}

private enum LocalCaddyVoiceRenderer {
    static func render(_ input: CaddyVoiceInput) -> String {
        let decision = input.decision

        return [
            sentence(decision.play),
            sentence(decision.target),
            sentence(decision.safeMiss),
            sentence(decision.why),
            "Confidence is \(confidenceLabel(decision.confidence)).",
            sentence("The \(decision.alternate.type) alternate is \(decision.alternate.text)")
        ]
        .joined(separator: " ")
    }

    private static func sentence(_ text: String) -> String {
        guard let lastCharacter = text.last else { return text }
        guard !".!?".contains(lastCharacter) else { return text }
        return text + "."
    }

    private static func confidenceLabel(_ confidence: ConfidenceBand) -> String {
        confidence == .mediumHigh ? "medium-high" : confidence.rawValue
    }
}
