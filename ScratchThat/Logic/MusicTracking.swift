//
//  MusicTracking.swift
//  ScratchThat
//
//  Created by Patryk Puciłowski on 12/07/2024.
//

import Foundation
import MediaPlayer

@Observable
class MusicTracking {
    var albumArt: UIImage?
    var songTitle: String
    var author: String

    var trackingStatus = true
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer

    /// Make an Event Listener to listen to the event. But it wont work without getting the selected function running
    func recordPlaying() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateSong), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: musicPlayer)
        musicPlayer.beginGeneratingPlaybackNotifications()
        trackingStatus = true
    }

    /// Run this gagatek and that Event listener up there will work
    @objc func updateSong() {
        if let nowPlayingItem = musicPlayer.nowPlayingItem {
            albumArt = (nowPlayingItem.artwork?.image(at: CGSize(width: 100, height: 100))) /*?? UIImage(systemName: "music.note")!*/
            // this SF Symbol for music note is only so when it compiles and the
            songTitle = nowPlayingItem.title ?? ""
            author = nowPlayingItem.artist ?? ""
        } else {
            print("Nothing is playing")
        }
    }

    // This cursed aah function that I had to trigger SO IT FUCKING WORKS AHDFSIJFHAIS

    func stopRecording() {
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: musicPlayer)
        musicPlayer.endGeneratingPlaybackNotifications()
        songTitle = ""
        author = ""

        trackingStatus = false
    }

    // this will be useful later

    init(albumArt: UIImage, songTitle: String, author: String, trackingStatus: Bool = true) {
        self.albumArt = albumArt
        self.songTitle = songTitle
        self.author = author
        self.trackingStatus = trackingStatus
    }
}
