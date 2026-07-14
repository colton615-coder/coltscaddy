import SwiftUI

struct ShotInputTray: View {
    enum ShotType: String, CaseIterable, Identifiable {
        case full = "Full"
        case chip = "Chip"
        case putt = "Putt"
        case tee = "Tee"

        var id: String { rawValue }
    }

    enum Lie: String, CaseIterable, Identifiable {
        case tee = "Tee"
        case fairway = "Fairway"
        case rough = "Rough"
        case sand = "Sand"

        var id: String { rawValue }
    }

    enum Trouble: String, CaseIterable, Identifiable {
        case water = "Water"
        case ob = "OB"
        case trees = "Trees"
        case bunker = "Bunker"
        case none = "None"

        var id: String { rawValue }
    }

    let onSubmit: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var shotType: ShotType = .full
    @State private var lie: Lie = .fairway
    @State private var selectedTrouble: Set<Trouble> = [.none]
    @State private var distance = ""

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.lg) {
            Text("Build the shot")
                .font(DS.Font.playCall)
                .foregroundStyle(DS.Color.textPrimary)

            VStack(alignment: .leading, spacing: DS.Spacing.lg) {
                SingleSelectSection(title: "Shot type", options: ShotType.allCases, selection: $shotType)
                SingleSelectSection(title: "Lie", options: Lie.allCases, selection: $lie)
                troubleSection
                distanceSection
            }

            Button {
                onSubmit(summary)
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
        .background(DS.Color.bg.ignoresSafeArea())
        .presentationDetents([.height(480)])
    }

    private var troubleSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            FieldLabel("Trouble")

            TroublePillGrid(options: Trouble.allCases) { trouble in
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

    private var readableTrouble: String {
        let activeTrouble = selectedTrouble.filter { $0 != .none }

        guard !activeTrouble.isEmpty else {
            return "no trouble marked"
        }

        let names = activeTrouble
            .map(\.rawValue)
            .sorted()
            .map { $0.lowercased() }
            .joined(separator: ", ")

        return "trouble marked: \(names)"
    }

    private func toggleTrouble(_ trouble: Trouble) {
        if trouble == .none {
            selectedTrouble = [.none]
            return
        }

        selectedTrouble.remove(.none)

        if selectedTrouble.contains(trouble) {
            selectedTrouble.remove(trouble)
        } else {
            selectedTrouble.insert(trouble)
        }

        if selectedTrouble.isEmpty {
            selectedTrouble = [.none]
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
