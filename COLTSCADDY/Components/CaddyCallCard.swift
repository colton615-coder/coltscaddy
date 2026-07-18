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
    let alternate: Alternate?
    let executionTip: String
    let isLogResultEnabled: Bool
    let expansionAction: (Bool) -> Void
    let logAction: () -> Void

    @State private var isAlternateExpanded = false
    @State private var isTipExpanded = false

    init(
        club: String,
        distanceText: String,
        target: String,
        safeMiss: String,
        why: String,
        alternate: Alternate? = nil,
        executionTip: String,
        isLogResultEnabled: Bool = true,
        expansionAction: @escaping (Bool) -> Void = { _ in },
        logAction: @escaping () -> Void = {}
    ) {
        self.club = club
        self.distanceText = distanceText
        self.target = target
        self.safeMiss = safeMiss
        self.why = why
        self.alternate = alternate
        self.executionTip = executionTip
        self.isLogResultEnabled = isLogResultEnabled
        self.expansionAction = expansionAction
        self.logAction = logAction
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            VStack(alignment: .leading, spacing: DS.Spacing.sm) {
                Text("CADDY CALL")
                    .font(DS.Font.caption)
                    .tracking(DS.Font.captionTracking)
                    .foregroundStyle(DS.Color.accent)

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
                    alternateDisclosure(alternate)
                }
            }

            Rectangle()
                .fill(DS.Color.accent)
                .frame(height: 1)

            if isTipExpanded {
                VStack(alignment: .leading, spacing: DS.Spacing.sm) {
                    Text("COMMIT TO THIS")
                        .font(DS.Font.sectionLabel)
                        .tracking(DS.Font.captionTracking)
                        .foregroundStyle(DS.Color.accent)

                    Text(executionTip)
                        .font(DS.Font.commitCue)
                        .foregroundStyle(DS.Color.textPrimary)
                        .accessibilityIdentifier("executionTip")
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }

            Button(action: logAction) {
                Text("Log result")
                    .font(DS.Font.button)
                    .foregroundStyle(DS.Color.accentInk)
                    .frame(maxWidth: .infinity, minHeight: DS.Size.tapTarget)
                    .background(
                        RoundedRectangle(cornerRadius: DS.Radius.button, style: .continuous)
                            .fill(DS.Color.accent)
                    )
            }
            .buttonStyle(.plain)
            .disabled(!isLogResultEnabled)
            .opacity(isLogResultEnabled ? 1 : 0.45)

            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isTipExpanded.toggle()
                }
                expansionAction(isTipExpanded)
            } label: {
                HStack(spacing: DS.Spacing.sm) {
                    Text(isTipExpanded ? "Hide reminder" : "Remind me how")
                    Image(systemName: isTipExpanded ? "chevron.up" : "chevron.down")
                }
                .font(DS.Font.label)
                .foregroundStyle(DS.Color.accent)
                .frame(maxWidth: .infinity, minHeight: DS.Size.tapTarget)
            }
            .buttonStyle(.plain)
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

    private func alternateDisclosure(_ alternate: Alternate) -> some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isAlternateExpanded.toggle()
                }
                expansionAction(isAlternateExpanded)
            } label: {
                HStack(spacing: DS.Spacing.sm) {
                    Text("Alternate play")
                    Spacer(minLength: DS.Spacing.md)
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isAlternateExpanded ? 180 : 0))
                }
                .font(DS.Font.button)
                .foregroundStyle(DS.Color.accentInk)
                .padding(.horizontal, DS.Spacing.md)
                .frame(maxWidth: .infinity, minHeight: DS.Size.tapTarget)
                .background(
                    RoundedRectangle(cornerRadius: DS.Radius.button, style: .continuous)
                        .fill(DS.Color.alternate)
                )
            }
            .buttonStyle(.plain)

            if isAlternateExpanded {
                Text(alternate.text)
                    .font(DS.Font.fieldValue)
                    .foregroundStyle(DS.Color.callDetail)
                    .accessibilityIdentifier("alternatePlay")
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
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
                .foregroundStyle(DS.Color.callDetail)
                .monospacedDigit()
        }
    }
}

#Preview {
    CaddyCallCard(
        club: "7 Iron",
        distanceText: "165 yds",
        target: "Center green.",
        safeMiss: "Short is fine.",
        why: "Stock number. No need to force it.",
        alternate: .init(type: "safer", text: "8 Iron to the front number."),
        executionTip: CaddyEngine.executionTip(for: .full)
    )
    .padding(DS.Spacing.xl)
    .background(DS.Color.bg)
}
