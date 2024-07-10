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
                        Text("Nothing is playing")

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

@Observable
class MusicThings {
    var songTitle: String
    var author: String

    var trackingStatus = true
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer

    /// Make an Event Listener to listen to the event. But it wont work without getting the selected function running
    func recordPlaying() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateSong), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: musicPlayer)
        musicPlayer.beginGeneratingPlaybackNotifications()
        print("Notifications should be set up")
        trackingStatus = true
    }

    /// Run this gagatek and that Event listener up there will work
    @objc func updateSong() {
        if let nowPlayingItem = musicPlayer.nowPlayingItem {
            songTitle = nowPlayingItem.title ?? ""
            author = nowPlayingItem.artist ?? ""
            print("Playing \(songTitle)")
        } else {
            print("Nothing is playing")
        }
    }

    // This cursed aah function that I had to trigger SO IT FUCKING WORKS AHDFSIJFHAIS

    func stopRecording() {
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: musicPlayer)
        musicPlayer.endGeneratingPlaybackNotifications()
        print("Rip notifications")
        songTitle = ""
        author = ""

        trackingStatus = false
    }

    // this will be useful later

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
