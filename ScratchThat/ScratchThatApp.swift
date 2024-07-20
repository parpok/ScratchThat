//
//  ScratchThatApp.swift
//  ScratchThat
//
//  Created by Patryk Puciłowski on 06/07/2024.
//

import SwiftUI
import SwiftData

@main
struct ScratchThatApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: TrackedSongs.self)
    }
}
