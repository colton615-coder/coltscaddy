//
//  COLTSCADDYApp.swift
//  COLTSCADDY
//
//  Created by Colton Thomas on 7/11/26.
//

import SwiftUI
import SwiftData

@main
struct COLTSCADDYApp: App {
    private let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(
                for: ShotContext.self,
                ShotHistory.self,
                PlayerProfile.self,
                ClubDistance.self,
                Tendency.self,
                CoachingCue.self
            )
            try ProfileSeeder.seedIfNeeded(in: container.mainContext)
#if DEBUG
            try Self.resetHistoryForUITestingIfNeeded(in: container.mainContext)
#endif
        } catch {
            fatalError("Failed to set up persistence: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            AppShellView()
                .preferredColorScheme(DS.preferredColorScheme)
        }
        .modelContainer(container)
    }
}

#if DEBUG
private extension COLTSCADDYApp {
    static func resetHistoryForUITestingIfNeeded(in modelContext: ModelContext) throws {
        guard ProcessInfo.processInfo.arguments.contains("-UITestResetHistory") else {
            return
        }

        let histories = try modelContext.fetch(FetchDescriptor<ShotHistory>())
        histories.forEach(modelContext.delete)
        try modelContext.save()
    }
}
#endif
