//
//  ContentView.swift
//  ScratchThat
//
//  Created by Patryk Puciłowski on 06/07/2024.
//

import MediaPlayer
import SwiftUI

struct ContentView: View {
    @State private var isMediaOK = MPMediaLibrary.authorizationStatus()

    @State private var stuff = MusicThings(songTitle: "", author: "")
    var body: some View {
        VStack {
            if isMediaOK == .authorized {
                Text("Now playing \(stuff.songTitle) by \(stuff.author)")
                    .onAppear {
                        stuff.recordPlaying()
                    }
            } else {
                Text("Sorry you need to authorize use of Media player to work")

                Button(action: {
                    Task {
                        let status = await MPMediaLibrary.requestAuthorization()
                        DispatchQueue.main.async {
                            self.isMediaOK = status
                        }
                    }
                }) {
                    Text("Ask for permission")
                }
                .buttonBorderShape(.roundedRectangle)
                .buttonStyle(.borderedProminent)
            }
        }.onAppear {
            isMediaOK = MPMediaLibrary.authorizationStatus()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

@Observable
class MusicThings {
    var songTitle: String
    var author: String
    func recordPlaying() {
        let musicPlayer = MPMusicPlayerController.systemMusicPlayer
        if let nowPlayingItem = musicPlayer.nowPlayingItem {
            print(nowPlayingItem.title ?? "")
            songTitle = nowPlayingItem.title ?? ""
            author = nowPlayingItem.artist ?? ""
        } else {
            print("Nothing's playing")
        }
    }

    init(songTitle: String, author: String) {
        self.songTitle = songTitle
        self.author = author
    }
}
