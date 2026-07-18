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
        } catch {
            fatalError("Failed to set up persistence: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ThreadView()
                .preferredColorScheme(DS.preferredColorScheme)
        }
        .modelContainer(container)
    }
}
