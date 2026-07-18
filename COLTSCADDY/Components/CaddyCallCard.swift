import SwiftUI

struct CaddyCallCard: View {
    struct Alternate {
        let type: String
        let text: String
    }

    let club: String
    let distanceText: String
    let target: String
    let safeMiss: String
    let why: String
    let confidence: String
    let alternate: Alternate?
    let executionTip: String
    let isLogResultEnabled: Bool
    let tipExpansionAction: (Bool) -> Void
    let logAction: () -> Void

    @State private var isTipExpanded = false

    init(
        club: String,
        distanceText: String,
        target: String,
        safeMiss: String,
        why: String,
        confidence: String,
        alternate: Alternate? = nil,
        executionTip: String,
        isLogResultEnabled: Bool = true,
        tipExpansionAction: @escaping (Bool) -> Void = { _ in },
        logAction: @escaping () -> Void = {}
    ) {
        self.club = club
        self.distanceText = distanceText
        self.target = target
        self.safeMiss = safeMiss
        self.why = why
        self.confidence = confidence
        self.alternate = alternate
        self.executionTip = executionTip
        self.isLogResultEnabled = isLogResultEnabled
        self.tipExpansionAction = tipExpansionAction
        self.logAction = logAction
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.lg) {
            VStack(alignment: .leading, spacing: DS.Spacing.sm) {
                HStack(alignment: .center) {
                    Text("CADDY CALL")
                        .font(DS.Font.caption)
                        .tracking(DS.Font.captionTracking)
                        .foregroundStyle(DS.Color.accent)

                    Spacer(minLength: DS.Spacing.md)

                    ConfidenceBadge(text: confidence)
                }

                Text(club)
                    .font(DS.Font.playCall)
                    .foregroundStyle(DS.Color.textPrimary)
                    .monospacedDigit()

                Text(distanceText)
                    .font(DS.Font.playDistance)
                    .foregroundStyle(DS.Color.accent)
                    .monospacedDigit()
            }

            VStack(alignment: .leading, spacing: DS.Spacing.md) {
                FieldBlock(label: "Target", value: target)
                FieldBlock(label: "Safe miss", value: safeMiss)
                FieldBlock(label: "Why", value: why)

                if let alternate {
                    Rectangle()
                        .fill(DS.Color.hairline)
                        .frame(height: 1)

                    FieldBlock(label: "Alternate", value: alternate.text, labelColor: DS.Color.alternate)
                }
            }

            if isTipExpanded {
                Text(executionTip)
                    .font(DS.Font.body)
                    .foregroundStyle(DS.Color.textSecondary)
                    .accessibilityIdentifier("executionTip")
            }

            HStack(spacing: DS.Spacing.sm) {
                quietButton("Remind me how") {
                    isTipExpanded.toggle()
                    tipExpansionAction(isTipExpanded)
                }
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

private struct ConfidenceBadge: View {
    let text: String

    var body: some View {
        Text(text)
            .font(DS.Font.badge)
            .foregroundStyle(DS.Color.confidence)
            .padding(.horizontal, DS.Spacing.sm)
            .padding(.vertical, DS.Spacing.xs)
            .background(
                RoundedRectangle(cornerRadius: DS.Radius.button, style: .continuous)
                    .fill(DS.Color.confidenceFill)
            )
    }
}

private struct FieldBlock: View {
    let label: String
    let value: String
    var labelColor = DS.Color.textPrimary

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            Text(label)
                .font(DS.Font.fieldLabel)
                .foregroundStyle(labelColor)

            Text(value)
                .font(DS.Font.fieldValue)
                .foregroundStyle(DS.Color.textSecondary)
                .monospacedDigit()
        }
    }
}

#Preview {
    CaddyCallCard(
        club: "7 Iron",
        distanceText: "165 yds",
        target: "Start it at the right-center of the green.",
        safeMiss: "Short left leaves the easiest up-and-down.",
        why: "The fairway lie gives you enough control to favor the center and avoid the long-right bunker.",
        confidence: "Medium-high",
        alternate: .init(type: "middle", text: "Aim center green and take the safer two-putt path."),
        executionTip: CaddyEngine.executionTip(for: .full)
    )
    .padding(DS.Spacing.xl)
    .background(DS.Color.bg)
}
