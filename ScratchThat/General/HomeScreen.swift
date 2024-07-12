//
//  HomeScreen.swift
//  ScratchThat
//
//  Created by Patryk Puciłowski on 12/07/2024.
//

import SwiftUI

struct HomeScreen: View {
    @State private var stuff = MusicTracking(songTitle: "", author: "")

    var body: some View {
        VStack {
            if !stuff.songTitle.isEmpty && !stuff.author.isEmpty {
                Text("Now playing \(stuff.songTitle) by \(stuff.author)")

                if stuff.trackingStatus == true {
                    Button {
                        stuff.stopRecording()
                    } label: {
                        Text("Stop recording playback")
                    }.buttonStyle(.borderedProminent)
                } else {
                    Button {
                        stuff.recordPlaying()
                        stuff.updateSong()
                    } label: {
                        Text("Re-start recording playback")
                    }.buttonStyle(.borderedProminent)
                }
            } else {
               
                if stuff.trackingStatus == true{
                    Text("Waiting for content")
                } else {
                     Text("Nothing is playing and tracing is off")
                }
                Button {
                    stuff.recordPlaying()
                    stuff.updateSong()
                } label: {
                    Text("Record playing")
                }.buttonStyle(.borderedProminent)

                Button {
                    stuff.stopRecording()
                } label: {
                    Text("Stop recording")
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
