import SwiftUI

struct ShotInputTray: View {
    enum ShotTypeOption: String, CaseIterable, Identifiable {
        case full = "Full"
        case chip = "Chip"
        case putt = "Putt"
        case tee = "Tee"

        var id: String { rawValue }
    }

    enum LieOption: String, CaseIterable, Identifiable {
        case tee = "Tee"
        case fairway = "Fairway"
        case rough = "Rough"
        case sand = "Sand"

        var id: String { rawValue }
    }

    enum TroubleOption: String, CaseIterable, Identifiable {
        case water = "Water"
        case ob = "OB"
        case trees = "Trees"
        case bunker = "Bunker"

        var id: String { rawValue }
    }

    let onSubmit: (ShotSubmission) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var shotType: ShotTypeOption = .full
    @State private var lie: LieOption = .fairway
    @State private var selectedTrouble: Set<TroubleOption> = []
    @State private var distance = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.Spacing.lg) {
                Text("Build the shot")
                    .font(DS.Font.screenTitle)
                    .foregroundStyle(DS.Color.textPrimary)

                VStack(alignment: .leading, spacing: DS.Spacing.lg) {
                    SingleSelectSection(title: "Shot type", options: ShotTypeOption.allCases, selection: $shotType)
                    SingleSelectSection(title: "Lie", options: LieOption.allCases, selection: $lie)
                    troubleSection
                    distanceSection
                }

                Button {
                    onSubmit(submission)
                    dismiss()
                } label: {
                    Text("Ask the caddie")
                        .font(DS.Font.label)
                        .foregroundStyle(DS.Color.accentInk)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: DS.Size.tapTarget)
                        .background(
                            RoundedRectangle(cornerRadius: DS.Radius.button, style: .continuous)
                                .fill(DS.Color.accent)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(.top, DS.Spacing.xl)
            .padding(.horizontal, DS.Spacing.xl)
            .padding(.bottom, DS.Spacing.xl)
        }
        .scrollIndicators(.hidden)
        .background(DS.Color.bg.ignoresSafeArea())
        .presentationDetents([.fraction(0.72), .large])
    }

    private var troubleSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            FieldLabel("Trouble")

            TroublePillGrid(options: TroubleOption.allCases) { trouble in
                PillButton(title: trouble.rawValue, isSelected: selectedTrouble.contains(trouble)) {
                    toggleTrouble(trouble)
                }
            }
        }
    }

    private var distanceSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            FieldLabel("Distance")

            TextField(text: $distance, prompt: Text("Yards").foregroundStyle(DS.Color.textTertiary)) {
                EmptyView()
            }
            .keyboardType(.numberPad)
            .accessibilityIdentifier("shotDistanceField")
            .font(DS.Font.body)
            .foregroundStyle(DS.Color.textPrimary)
            .tint(DS.Color.accent)
            .padding(.horizontal, DS.Spacing.lg)
            .frame(minHeight: DS.Size.tapTarget)
            .background(
                RoundedRectangle(cornerRadius: DS.Radius.button, style: .continuous)
                    .fill(DS.Color.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DS.Radius.button, style: .continuous)
                    .stroke(DS.Color.hairline)
            )
        }
    }

    private var summary: String {
        let trimmedDistance = distance.trimmingCharacters(in: .whitespacesAndNewlines)
        let distanceText = trimmedDistance.isEmpty ? "No distance entered" : "\(trimmedDistance) yards"
        let troubleText = readableTrouble

        return "\(distanceText), \(lie.rawValue.lowercased()), \(shotType.rawValue.lowercased()) shot, \(troubleText)."
    }

    private var submission: ShotSubmission {
        let trimmedDistance = distance.trimmingCharacters(in: .whitespacesAndNewlines)

        return ShotSubmission(
            input: CaddyShotInput(
                shotType: shotType.domainValue,
                lie: lie.domainValue,
                trouble: selectedTrouble.map(\.domainValue).sorted { $0.rawValue < $1.rawValue },
                distanceYards: Int(trimmedDistance) ?? 0
            ),
            summary: summary
        )
    }

    private var readableTrouble: String {
        guard !selectedTrouble.isEmpty else {
            return "no trouble marked"
        }

        let names = selectedTrouble
            .map(\.rawValue)
            .sorted()
            .map { $0.lowercased() }
            .joined(separator: ", ")

        return "trouble marked: \(names)"
    }

    private func toggleTrouble(_ trouble: TroubleOption) {
        if selectedTrouble.contains(trouble) {
            selectedTrouble.remove(trouble)
        } else {
            selectedTrouble.insert(trouble)
        }
    }
}

struct ShotSubmission: Equatable {
    let input: CaddyShotInput
    let summary: String

    func attachingNuance(_ rawNuance: String) -> ShotSubmission {
        let trimmedNuance = rawNuance.trimmingCharacters(in: .whitespacesAndNewlines)
        let nuance = trimmedNuance.isEmpty ? nil : trimmedNuance
        let updatedInput = CaddyShotInput(
            shotType: input.shotType,
            lie: input.lie,
            trouble: input.trouble,
            distanceYards: input.distanceYards,
            nuance: nuance
        )
        let updatedSummary = nuance.map { "\(summary) Nuance: \($0)" } ?? summary

        return ShotSubmission(input: updatedInput, summary: updatedSummary)
    }
}

private extension ShotInputTray.ShotTypeOption {
    var domainValue: ShotType {
        switch self {
        case .full: .full
        case .chip: .chip
        case .putt: .putt
        case .tee: .tee
        }
    }
}

private extension ShotInputTray.LieOption {
    var domainValue: Lie {
        switch self {
        case .tee: .tee
        case .fairway: .fairway
        case .rough: .rough
        case .sand: .sand
        }
    }
}

private extension ShotInputTray.TroubleOption {
    var domainValue: Trouble {
        switch self {
        case .water: .water
        case .ob: .ob
        case .trees: .trees
        case .bunker: .bunker
        }
    }
}

private struct SingleSelectSection<Option>: View where Option: CaseIterable & Identifiable & RawRepresentable & Hashable, Option.RawValue == String {
    let title: String
    let options: [Option]
    @Binding var selection: Option

    init(title: String, options: [Option], selection: Binding<Option>) {
        self.title = title
        self.options = options
        self._selection = selection
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            FieldLabel(title)

            EqualPillRow(options: options) { option in
                PillButton(title: option.rawValue, isSelected: selection == option) {
                    selection = option
                }
            }
        }
    }
}

private struct EqualPillRow<Option, Content>: View where Option: Identifiable, Content: View {
    let options: [Option]
    @ViewBuilder let content: (Option) -> Content

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: DS.Spacing.sm), count: 4)
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: DS.Spacing.sm) {
            ForEach(options) { option in
                content(option)
            }
        }
    }
}

private struct TroublePillGrid<Option, Content>: View where Option: Identifiable, Content: View {
    let options: [Option]
    @ViewBuilder let content: (Option) -> Content

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: DS.Spacing.sm), count: 3)
    }

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: DS.Spacing.sm) {
            ForEach(options) { option in
                content(option)
            }
        }
    }
}

private struct PillButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DS.Font.label)
                .foregroundStyle(isSelected ? DS.Color.accentInk : DS.Color.textPrimary)
                .padding(.horizontal, DS.Spacing.md)
                .padding(.vertical, DS.Spacing.sm)
                .frame(maxWidth: .infinity)
                .frame(minHeight: DS.Size.tapTarget)
                .background(
                    RoundedRectangle(cornerRadius: DS.Radius.button, style: .continuous)
                        .fill(isSelected ? DS.Color.accent : DS.Color.surface)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: DS.Radius.button, style: .continuous)
                        .stroke(isSelected ? DS.Color.accent : DS.Color.hairline, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

private struct FieldLabel: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title.uppercased())
            .font(DS.Font.caption)
            .tracking(DS.Font.captionTracking)
            .foregroundStyle(DS.Color.textSecondary)
    }
}

#Preview {
    ShotInputTray { _ in }
}
