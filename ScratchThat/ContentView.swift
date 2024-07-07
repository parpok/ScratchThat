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
                if !stuff.songTitle.isEmpty && !stuff.author.isEmpty {
                    Text("Now playing \(stuff.songTitle) by \(stuff.author)").onAppear { stuff.recordPlaying()
                    }
                } else {
                    Text("Nothing is playing").onAppear { stuff.recordPlaying()
                    }
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
            guard isMediaOK == .authorized else { return print("USER IS NOT OK WITH MEDIA STOP RIGHT HERE")
            }
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
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer

    func recordPlaying() {
        print("Starting to listen")
        
        self.songTitle = self.musicPlayer.nowPlayingItem?.title ?? ""
        
        self.author = self.musicPlayer.nowPlayingItem?.artist ?? ""
        
        print("Starting to send notifications")
        musicPlayer.beginGeneratingPlaybackNotifications()
    }

    init(songTitle: String, author: String) {
        self.songTitle = songTitle
        self.author = author
    }
}
