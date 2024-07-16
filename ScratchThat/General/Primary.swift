//
//  Primary.swift
//  ScratchThat
//
//  Created by Patryk Puciłowski on 12/07/2024.
//

import SwiftUI

struct MainScreen: View {
    @Environment(\.modelContext) private var ModelContext
    @State private var stuff = MusicTracking(albumArt: UIImage(systemName: "music.note")!, songTitle: "", author: "", album: "")

    var body: some View {
        VStack {
            if !stuff.songTitle.isEmpty && !stuff.author.isEmpty {
                VStack {
                    Image(uiImage: (stuff.albumArt ?? UIImage(systemName: "music.note"))!)
                        .resizable()
                        .scaledToFit()
                    Text("Now playing \(stuff.songTitle) by \(stuff.author)")
                }.onChange(of: stuff.songTitle) {
                    ModelContext.insert(TrackedSongs(id: UUID(), Title: stuff.songTitle, Artist: stuff.author, Album: stuff.albumName, AlbumART: stuff.albumArt?.pngData(), DateTracked: Date.now))
                }
                if stuff.trackingStatus == true {
                    Button {
                        stuff.stopRecording()
                        
//                        stuff.author = ""
//                        stuff.songTitle = ""
//                        stuff.albumName = ""
//                        stuff.albumArt = UIImage(systemName: "music.note")
                        
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
