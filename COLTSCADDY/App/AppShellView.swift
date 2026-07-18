import SwiftData
import SwiftUI

struct AppShellView: View {
    private enum AppTab: Hashable {
        case play
        case history
    }

    @State private var selectedTab: AppTab = .play

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Play", systemImage: "figure.golf", value: AppTab.play) {
                NavigationStack {
                    ThreadView()
                        .toolbar(.hidden, for: .navigationBar)
                }
            }

            Tab("History", systemImage: "clock.arrow.circlepath", value: AppTab.history) {
                NavigationStack {
                    HistoryView {
                        selectedTab = .play
                    }
                }
            }
        }
        .tint(DS.Color.accent)
    }
}

#Preview {
    AppShellView()
        .modelContainer(
            for: [
                ShotContext.self,
                ShotHistory.self,
                PlayerProfile.self,
                ClubDistance.self,
                Tendency.self,
                CoachingCue.self
            ],
            inMemory: true
        )
}
