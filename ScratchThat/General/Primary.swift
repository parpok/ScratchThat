//
//  Primary.swift
//  ScratchThat
//
//  Created by Patryk Puciłowski on 12/07/2024.
//

import SwiftUI

struct MainScreen: View {
    @State private var stuff = MusicTracking(songTitle: "", author: "")

    var body: some View {
        VStack {
            if !stuff.songTitle.isEmpty && !stuff.author.isEmpty {
                Text("Now playing \(stuff.songTitle) by \(stuff.author)")

                if stuff.trackingStatus == true {
                    Button {
                        stuff.stopRecording()
                    } label: {
                        Text("Stop updating status")
                    }.buttonStyle(.borderedProminent)
                } else {
                    Button {
                        stuff.recordPlaying()
                        stuff.updateSong()
                    } label: {
                        Text("Restart updating status")
                    }.buttonStyle(.borderedProminent)
                }
            } else {
                if stuff.trackingStatus == true {
                    Text("Updating status")
                    Text("Waiting for content")
                } else {
                    Text("Nothing is playing and tracking is off")
                }
                Button {
                    stuff.recordPlaying()
                    stuff.updateSong()
                } label: {
                    Text("Start updating status")
                }.buttonStyle(.borderedProminent)

                Button {
                    stuff.stopRecording()
                } label: {
                    Text("Stop updating status")
                }.buttonStyle(.borderedProminent)
            }
        }.onAppear {
            stuff.recordPlaying()
            stuff.updateSong()
        }
    }
}

#Preview {
    HomeScreen()
}
