import SwiftUI
import SwiftData

struct BagEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var profiles: [PlayerProfile]

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.lg) {
            Text("Your bag")
                .font(DS.Font.playCall)
                .foregroundStyle(DS.Color.textPrimary)

            Text("Carry yards for each club. The caddie picks from these numbers.")
                .font(DS.Font.label)
                .foregroundStyle(DS.Color.textSecondary)

            ScrollView {
                VStack(spacing: DS.Spacing.sm) {
                    ForEach(sortedClubs) { club in
                        ClubRow(club: club)
                    }
                }
            }
            .scrollIndicators(.hidden)

            Button {
                dismiss()
            } label: {
                Text("Done")
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
    }

    // Rows follow the canonical bag order rather than carry yards, so a club
    // does not jump to a new position while its number is being typed.
    private var sortedClubs: [ClubDistance] {
        let clubs = profiles.first?.clubDistances ?? []

        return clubs.sorted { lhs, rhs in
            let lhsIndex = ProfileSeeder.bagOrder.firstIndex(of: lhs.clubName) ?? .max
            let rhsIndex = ProfileSeeder.bagOrder.firstIndex(of: rhs.clubName) ?? .max
            return lhsIndex < rhsIndex
        }
    }
}

private struct ClubRow: View {
    @Bindable var club: ClubDistance

    var body: some View {
        HStack(spacing: DS.Spacing.md) {
            Text(club.clubName)
                .font(DS.Font.body)
                .foregroundStyle(DS.Color.textPrimary)

            Spacer()

            TextField("Yards", value: $club.carryYards, format: .number)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
                .font(DS.Font.body)
                .foregroundStyle(DS.Color.textPrimary)
                .tint(DS.Color.accent)
                .frame(width: 80)
        }
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

#Preview {
    BagEditorView()
        .modelContainer(for: PlayerProfile.self, inMemory: true)
}
