//
//  ContentView.swift
//  ScratchThat
//
//  Created by Patryk Puciłowski on 06/07/2024.
//

import MediaPlayer
import SwiftUI

struct ContentView: View {
    @State private var stuff = MusicThings(songTitle: "", author: "")
    @State private var consent = mediaConsent()
    var body: some View {
        VStack {
            switch consent.consent {
            case .authorized:
                if !stuff.songTitle.isEmpty && !stuff.author.isEmpty {
                    Text("Now playing \(stuff.songTitle) by \(stuff.author)").onAppear {
                        stuff.recordPlaying()
                    }
                } else {
                    Text("Nothing is playing").onAppear {
                        stuff.recordPlaying()
                    }
                }

            case .notDetermined:
                Text("Welcome to ScratchThat").onAppear {
                    consent.requestConsent()
                }

            case .denied:
                Text("Sorry you need to authorize use of Media player to work")

                Button(action: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Ask for permission")
                }
                .buttonBorderShape(.roundedRectangle)
                .buttonStyle(.borderedProminent)
            case .restricted:
                Text("Sorry you need to authorize use of Media player to work")

                Button(action: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Ask for permission")
                }
                .buttonBorderShape(.roundedRectangle)
                .buttonStyle(.borderedProminent)
            @unknown default:
                fatalError("UNKNOWN AUTHORIZATION STATUS")
            }
        }.padding().onChange(of: consent.consent) {
            print("UPDAATE UI")
        }
    }
}

#Preview {
    ContentView()
}

class MusicThings {
    var songTitle: String
    var author: String
    let musicPlayer = MPMusicPlayerController.applicationMusicPlayer

    func recordPlaying() {
        print("Starting to listen")

        NotificationCenter.default.addObserver(forName: Notification.Name("MPMusicPlayerControllerNowPlayingItemDidChangeNotification"), object: musicPlayer, queue: .main) { _ in
            let musicPlayer = self.musicPlayer
            self.songTitle = (musicPlayer.nowPlayingItem?.title)!
            self.author = (musicPlayer.nowPlayingItem?.artist)!
            print("Now playing \(self.songTitle)")
        }
        print("Starting to send notifications")
        musicPlayer.beginGeneratingPlaybackNotifications()
    }

    init(songTitle: String, author: String) {
        self.songTitle = songTitle
        self.author = author
    }
}

@Observable
class mediaConsent {
    var consent = MPMediaLibrary.authorizationStatus()

    init(consent: MPMediaLibraryAuthorizationStatus = MPMediaLibrary.authorizationStatus()) {
        self.consent = consent
    }

    func requestConsent() {
        Task {
            let status = await MPMediaLibrary.requestAuthorization()
            DispatchQueue.main.async {
                self.consent = status
            }
        }
    }
}
