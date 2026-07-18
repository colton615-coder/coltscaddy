import SwiftUI

struct OutcomePickerSheet: View {
    let club: String
    let distanceText: String
    let selectOutcome: (Outcome) -> Void

    @Environment(\.dismiss) private var dismiss

    private let columns = [
        GridItem(.flexible(), spacing: DS.Spacing.md),
        GridItem(.flexible(), spacing: DS.Spacing.md)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.lg) {
            VStack(alignment: .leading, spacing: DS.Spacing.xs) {
                Text("How did it go?")
                    .font(DS.Font.screenTitle)
                    .foregroundStyle(DS.Color.textPrimary)

                Text("Log the finish for \(club) · \(distanceText).")
                    .font(DS.Font.body)
                    .foregroundStyle(DS.Color.callDetail)
            }

            VStack(spacing: DS.Spacing.md) {
                LazyVGrid(columns: columns, spacing: DS.Spacing.md) {
                    ForEach(Outcome.allCases, id: \.self) { outcome in
                        Button {
                            selectOutcome(outcome)
                            dismiss()
                        } label: {
                            Text(outcome.displayName)
                                .font(DS.Font.button)
                                .foregroundStyle(DS.Color.textPrimary)
                                .frame(maxWidth: .infinity, minHeight: 52)
                                .background(
                                    RoundedRectangle(cornerRadius: DS.Radius.button, style: .continuous)
                                        .fill(DS.Color.bg)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: DS.Radius.button, style: .continuous)
                                        .stroke(DS.Color.hairline)
                                )
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("outcome-\(outcome.rawValue)")
                        .accessibilityLabel("Log \(outcome.displayName.lowercased()) outcome")
                    }
                }

                Button("Cancel") {
                    dismiss()
                }
                .font(DS.Font.button)
                .foregroundStyle(DS.Color.accent)
                .frame(maxWidth: .infinity, minHeight: DS.Size.tapTarget)
                .buttonStyle(.plain)
                .accessibilityIdentifier("outcomeCancelButton")
            }
        }
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.vertical, DS.Spacing.lg)
        .background(DS.Color.surface)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("outcomePicker")
    }
}

#Preview {
    OutcomePickerSheet(
        club: "7 Iron",
        distanceText: "165 yds",
        selectOutcome: { _ in }
    )
    .presentationDetents([.height(344)])
    .presentationDragIndicator(.visible)
}
