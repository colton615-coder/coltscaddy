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

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

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
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: DS.Spacing.lg) {
                Text("CADDY CALL")
                    .font(DS.Font.caption)
                    .tracking(DS.Font.captionTracking)
                    .foregroundStyle(DS.Color.accent)

                recommendationLockup
                targetCommand
            }

            sectionDivider
                .padding(.vertical, DS.Spacing.lg)

            callDetails

            if let alternate {
                sectionDivider
                    .padding(.top, DS.Spacing.lg)

                alternateDisclosure(alternate)
            }

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
                .padding(.top, DS.Spacing.lg)
                .transition(reduceMotion ? .opacity : .opacity.combined(with: .move(edge: .top)))
            }

            sectionDivider
                .padding(.top, DS.Spacing.lg)

            actionRail
                .padding(.top, DS.Spacing.md)
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

    private var recommendationLockup: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .center, spacing: DS.Spacing.md) {
                clubLabel

                Spacer(minLength: 0)

                Rectangle()
                    .fill(DS.Color.hairline)
                    .frame(width: 1, height: 36)

                distanceLabel
            }

            VStack(alignment: .leading, spacing: DS.Spacing.sm) {
                clubLabel
                distanceLabel
            }
        }
    }

    private var clubLabel: some View {
        HStack(spacing: DS.Spacing.sm) {
            Image(systemName: "figure.golf")
                .font(.title2.weight(.medium))
                .accessibilityHidden(true)

            Text(club)
                .font(DS.Font.playCall)
                .lineLimit(1)
                .minimumScaleFactor(0.72)
                .monospacedDigit()
        }
        .foregroundStyle(DS.Color.textPrimary)
    }

    private var distanceLabel: some View {
        Text(distanceText)
            .font(DS.Font.playDistance)
            .foregroundStyle(DS.Color.accent)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .monospacedDigit()
    }

    private var targetCommand: some View {
        HStack(alignment: .center, spacing: DS.Spacing.md) {
            RoundedRectangle(cornerRadius: 1, style: .continuous)
                .fill(DS.Color.accent)
                .frame(width: 3)

            Text(displayTarget)
                .font(DS.Font.playTarget)
                .foregroundStyle(DS.Color.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityIdentifier("targetCommand")
        }
    }

    @ViewBuilder
    private var callDetails: some View {
        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: DS.Spacing.lg) {
                CompactFieldBlock(label: "Safe miss", value: safeMiss, valueIdentifier: "safeMissValue")
                CompactFieldBlock(label: "Why", value: why, valueIdentifier: "whyValue")
            }
        } else {
            HStack(alignment: .top, spacing: DS.Spacing.lg) {
                CompactFieldBlock(label: "Safe miss", value: safeMiss, valueIdentifier: "safeMissValue")
                    .frame(maxWidth: .infinity, alignment: .leading)

                Rectangle()
                    .fill(DS.Color.hairline)
                    .frame(width: 1)

                CompactFieldBlock(label: "Why", value: why, valueIdentifier: "whyValue")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func alternateDisclosure(_ alternate: Alternate) -> some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            Button {
                withAnimation(disclosureAnimation) {
                    isAlternateExpanded.toggle()
                }
                expansionAction(isAlternateExpanded)
            } label: {
                HStack(spacing: DS.Spacing.sm) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .accessibilityHidden(true)
                    Text("Alternate")
                    Spacer(minLength: DS.Spacing.md)
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isAlternateExpanded ? 90 : 0))
                        .accessibilityHidden(true)
                }
                .font(DS.Font.label)
                .foregroundStyle(DS.Color.alternate)
                .frame(maxWidth: .infinity, minHeight: DS.Size.tapTarget)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Alternate play")

            if isAlternateExpanded {
                Text(alternate.text)
                    .font(DS.Font.fieldValue)
                    .foregroundStyle(DS.Color.callDetail)
                    .accessibilityIdentifier("alternatePlay")
                    .transition(reduceMotion ? .opacity : .opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    @ViewBuilder
    private var actionRail: some View {
        if dynamicTypeSize.isAccessibilitySize {
            VStack(spacing: DS.Spacing.sm) {
                reminderButton
                logResultButton
            }
        } else {
            HStack(spacing: DS.Spacing.md) {
                reminderButton

                Rectangle()
                    .fill(DS.Color.hairline)
                    .frame(width: 1, height: DS.Size.tapTarget)

                logResultButton
            }
        }
    }

    private var reminderButton: some View {
        Button {
            withAnimation(disclosureAnimation) {
                isTipExpanded.toggle()
            }
            expansionAction(isTipExpanded)
        } label: {
            HStack(spacing: DS.Spacing.sm) {
                Image(systemName: isTipExpanded ? "bell.slash" : "bell")
                    .accessibilityHidden(true)
                Text(isTipExpanded ? "Hide reminder" : "Remind me")
            }
            .font(DS.Font.label)
            .foregroundStyle(DS.Color.callDetail)
            .frame(maxWidth: .infinity, minHeight: DS.Size.tapTarget)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isTipExpanded ? "Hide reminder" : "Remind me how")
        .accessibilityIdentifier("reminderButton")
    }

    private var logResultButton: some View {
        Button(action: logAction) {
            HStack(spacing: DS.Spacing.sm) {
                Image(systemName: "flag")
                    .accessibilityHidden(true)
                Text("Log result")
            }
            .font(DS.Font.label)
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
        .accessibilityIdentifier("logResultButton")
    }

    private var sectionDivider: some View {
        Rectangle()
            .fill(DS.Color.hairline)
            .frame(height: 1)
    }

    private var disclosureAnimation: Animation? {
        reduceMotion ? nil : .easeOut(duration: 0.2)
    }

    private var displayTarget: String {
        let trimmed = target.trimmingCharacters(in: .whitespacesAndNewlines)
        let sentence = trimmed.trimmingCharacters(in: CharacterSet(charactersIn: "."))
        let lowercasedSentence = sentence.lowercased()

        if lowercasedSentence.hasPrefix("land ") {
            return sentence
        }

        if lowercasedSentence == "safely on" {
            return "Get it safely on"
        }

        guard let firstCharacter = sentence.first else {
            return "Aim at the safest target"
        }

        let loweredFirstCharacter = String(firstCharacter).lowercased()
        let normalizedSentence = "\(loweredFirstCharacter)\(sentence.dropFirst())"
        let targetsUsingDefiniteArticle = ["widest", "cleanest", "largest", "start"]
        let article = targetsUsingDefiniteArticle.contains {
            normalizedSentence.hasPrefix($0)
        } ? "the " : ""

        return "Aim at \(article)\(normalizedSentence)"
    }
}

private struct CompactFieldBlock: View {
    let label: String
    let value: String
    let valueIdentifier: String

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            Text(label.uppercased())
                .font(DS.Font.fieldLabel)
                .tracking(DS.Font.captionTracking)
                .foregroundStyle(DS.Color.textSecondary)

            Text(value)
                .font(DS.Font.fieldValue)
                .foregroundStyle(DS.Color.callDetail)
                .monospacedDigit()
                .accessibilityIdentifier(valueIdentifier)
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
