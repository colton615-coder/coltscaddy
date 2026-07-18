import SwiftData
import SwiftUI

struct HistoryView: View {
    @Query(sort: \ShotHistory.loggedAt, order: .reverse)
    private var histories: [ShotHistory]

    let playAction: () -> Void

    var body: some View {
        Group {
            if histories.isEmpty {
                emptyState
            } else {
                timeline
            }
        }
        .background(DS.Color.bg.ignoresSafeArea())
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.large)
    }

    private var emptyState: some View {
        VStack(spacing: DS.Spacing.lg) {
            Spacer()

            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 34, weight: .medium))
                .foregroundStyle(DS.Color.accent)
                .accessibilityHidden(true)

            VStack(spacing: DS.Spacing.sm) {
                Text("No shots yet")
                    .font(DS.Font.screenTitle)
                    .foregroundStyle(DS.Color.textPrimary)

                Text("Log a result in Play and your shots will appear here. Personal insights stay off until there is enough evidence and you confirm them.")
                    .font(DS.Font.body)
                    .foregroundStyle(DS.Color.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Button(action: playAction) {
                Text("Go to Play")
                    .font(DS.Font.button)
                    .foregroundStyle(DS.Color.accentInk)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: DS.Size.tapTarget)
                    .background(
                        RoundedRectangle(cornerRadius: DS.Radius.button, style: .continuous)
                            .fill(DS.Color.accent)
                    )
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(.horizontal, DS.Spacing.xl)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("historyEmptyState")
    }

    private var timeline: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: DS.Spacing.xxl) {
                learningStatus

                ForEach(historyDays) { day in
                    VStack(alignment: .leading, spacing: DS.Spacing.md) {
                        Text(dayTitle(for: day.date).uppercased())
                            .font(DS.Font.caption)
                            .tracking(DS.Font.captionTracking)
                            .foregroundStyle(DS.Color.textSecondary)

                        ForEach(day.shots, id: \.persistentModelID) { history in
                            HistoryShotRow(history: history)
                        }
                    }
                }
            }
            .padding(.horizontal, DS.Spacing.xl)
            .padding(.top, DS.Spacing.md)
            .padding(.bottom, DS.Spacing.xxl)
        }
        .scrollIndicators(.hidden)
        .accessibilityIdentifier("historyTimeline")
    }

    private var learningStatus: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            Text("STILL LEARNING")
                .font(DS.Font.caption)
                .tracking(DS.Font.captionTracking)
                .foregroundStyle(DS.Color.eyebrow)

            Text("Your logged shots are here. The caddie will not call a pattern personal until there is enough evidence and you confirm it.")
                .font(DS.Font.body)
                .foregroundStyle(DS.Color.callDetail)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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

    private var historyDays: [HistoryDay] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: histories) { history in
            calendar.startOfDay(for: history.loggedAt)
        }

        return grouped
            .map { HistoryDay(date: $0.key, shots: $0.value) }
            .sorted { $0.date > $1.date }
    }

    private func dayTitle(for date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Today"
        }

        return date.formatted(date: .long, time: .omitted)
    }
}

private struct HistoryDay: Identifiable {
    let date: Date
    let shots: [ShotHistory]

    var id: Date { date }
}

private struct HistoryShotRow: View {
    let history: ShotHistory

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.md) {
            HStack(alignment: .firstTextBaseline, spacing: DS.Spacing.md) {
                Text(history.recommendationGiven)
                    .font(DS.Font.fieldValue)
                    .foregroundStyle(DS.Color.textPrimary)

                Spacer(minLength: DS.Spacing.sm)

                Text(history.outcome?.displayName ?? "Result not recorded")
                    .font(DS.Font.caption)
                    .foregroundStyle(history.outcome == nil ? DS.Color.textSecondary : DS.Color.accent)
            }

            Text(contextSummary)
                .font(DS.Font.body)
                .foregroundStyle(DS.Color.textSecondary)

            Text(history.loggedAt.formatted(date: .omitted, time: .shortened))
                .font(DS.Font.caption)
                .foregroundStyle(DS.Color.textTertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DS.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DS.Radius.card, style: .continuous)
                .fill(DS.Color.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DS.Radius.card, style: .continuous)
                .stroke(DS.Color.hairline)
        )
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("historyShotRow")
    }

    private var contextSummary: String {
        let shotType = history.context.shotType.rawValue.capitalized
        let lie = history.context.lie.rawValue.capitalized
        return "\(history.context.distanceYards) yds · \(shotType) · \(lie)"
    }
}

#Preview("Empty") {
    NavigationStack {
        HistoryView(playAction: {})
    }
    .modelContainer(for: [ShotContext.self, ShotHistory.self], inMemory: true)
}
