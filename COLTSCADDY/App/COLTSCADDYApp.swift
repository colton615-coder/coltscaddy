//
//  COLTSCADDYApp.swift
//  COLTSCADDY
//
//  Created by Colton Thomas on 7/11/26.
//

import SwiftData
import SwiftUI

@main
struct COLTSCADDYApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            ShotContext.self,
            PlayerProfile.self,
            ClubDistance.self,
            ShotHistory.self,
            CoachingCue.self,
            Tendency.self
        ])
    }
}
