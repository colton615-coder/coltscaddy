import SwiftUI

struct CaddyCallCard: View {
    struct Alternate {
        let type: String
        let text: String
    }

    let play: String
    let target: String
    let safeMiss: String
    let why: String
    let confidence: String
    let alternate: Alternate?
    let isLogResultEnabled: Bool
    let remindAction: () -> Void
    let logAction: () -> Void

    init(
        play: String,
        target: String,
        safeMiss: String,
        why: String,
        confidence: String,
        alternate: Alternate? = nil,
        isLogResultEnabled: Bool = true,
        remindAction: @escaping () -> Void = {},
        logAction: @escaping () -> Void = {}
    ) {
        self.play = play
        self.target = target
        self.safeMiss = safeMiss
        self.why = why
        self.confidence = confidence
        self.alternate = alternate
        self.isLogResultEnabled = isLogResultEnabled
        self.remindAction = remindAction
        self.logAction = logAction
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.lg) {
            VStack(alignment: .leading, spacing: DS.Spacing.sm) {
                Text("CADDY CALL")
                    .font(DS.Font.caption)
                    .tracking(DS.Font.captionTracking)
                    .foregroundStyle(DS.Color.accent)

                Text(play)
                    .font(DS.Font.playCall)
                    .foregroundStyle(DS.Color.textPrimary)
                    .monospacedDigit()
            }

            VStack(alignment: .leading, spacing: DS.Spacing.sm) {
                FieldLine(name: "Target", value: target)
                FieldLine(name: "Safe miss", value: safeMiss)
                FieldLine(name: "Why", value: why)

                if let alternate {
                    FieldLine(name: "Alternate \(alternate.type)", value: alternate.text)
                }
            }

            Text(confidence.uppercased())
                .font(DS.Font.caption)
                .tracking(DS.Font.captionTracking)
                .foregroundStyle(DS.Color.textSecondary)

            HStack(spacing: DS.Spacing.sm) {
                quietButton("Remind me how", action: remindAction)
                Text("·")
                    .font(DS.Font.label)
                    .foregroundStyle(DS.Color.textTertiary)
                quietButton("Log result", action: logAction)
                    .disabled(!isLogResultEnabled)
            }
        }
        .padding(DS.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DS.Radius.card, style: .continuous)
                .fill(DS.Color.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DS.Radius.card, style: .continuous)
                .stroke(DS.Color.hairline)
        )
    }

    private func quietButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(DS.Font.label)
                .foregroundStyle(DS.Color.textSecondary)
                .frame(minHeight: DS.Size.tapTarget)
        }
        .buttonStyle(.plain)
    }
}

private struct FieldLine: View {
    let name: String
    let value: String

    var body: some View {
        Text(line)
            .font(DS.Font.label)
            .monospacedDigit()
    }

    private var line: AttributedString {
        var fieldName = AttributedString(name + ": ")
        fieldName.foregroundColor = DS.Color.textPrimary

        var fieldValue = AttributedString(value)
        fieldValue.foregroundColor = DS.Color.textSecondary

        return fieldName + fieldValue
    }
}

#Preview {
    CaddyCallCard(
        play: "165 yds · 7-iron controlled draw",
        target: "Start it at the right-center of the green.",
        safeMiss: "Short left leaves the easiest up-and-down.",
        why: "The fairway lie gives you enough control to favor the center and avoid the long-right bunker.",
        confidence: "Medium-high",
        alternate: .init(type: "middle", text: "Aim center green and take the safer two-putt path.")
    )
    .padding(DS.Spacing.xl)
    .background(DS.Color.bg)
}
