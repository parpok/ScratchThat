//
//  MusicTracking.swift
//  ScratchThat
//
//  Created by Patryk Puciłowski on 12/07/2024.
//

import Foundation
import MediaPlayer
import SwiftData
import OSLog

@Observable
class MusicTracking {
    var albumArt: UIImage?
    var songTitle: String
    var author: String
    var albumName: String

    var trackingStatus = true
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer

    /// Make an Event Listener to listen to the event. But it wont work without getting the selected function running
    func recordPlaying() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateSong), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: musicPlayer)
        musicPlayer.beginGeneratingPlaybackNotifications()
        trackingStatus = true
        os_log("Recording media playback", type: .info)
    }

    /// Run this gagatek and that Event listener up there will work
    @MainActor
    @objc func updateSong() {
        if let nowPlayingItem = musicPlayer.nowPlayingItem {
            albumArt = (nowPlayingItem.artwork?.image(at: CGSize(width: 1000, height: 1000))) /* ?? UIImage(systemName: "music.note")! */
            // this SF Symbol for music note is only so when it compiles and the
            songTitle = nowPlayingItem.title ?? ""
            author = nowPlayingItem.artist ?? ""
            albumName = nowPlayingItem.albumTitle ?? ""
            
        } else {
            os_log(.error, "Nothing is playing right now")
        }
    }

    // This cursed aah function that I had to trigger SO IT FUCKING WORKS AHDFSIJFHAIS
    func stopRecording() {
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: musicPlayer)
        musicPlayer.endGeneratingPlaybackNotifications()
        songTitle = ""
        author = ""
        albumName = ""
        albumArt = nil

        trackingStatus = false
        
        os_log("Stopped checking for playback notifications", type: .info)
    }
    
    init(albumArt: UIImage? = nil, songTitle: String, author: String, album: String, trackingStatus: Bool = true) {
        self.albumArt = albumArt
        self.songTitle = songTitle
        self.author = author
        albumName = album
        self.trackingStatus = trackingStatus
    }

    deinit {
        stopRecording()
    }
}

@Model
class TrackedSongs {
    var Title: String
    var Artist: String
    var Album: String

    @Attribute(.externalStorage)
    var AlbumART: Data?

    var DateTracked: Date

    init(Title: String, Artist: String, Album: String, AlbumART: Data? = nil, DateTracked: Date) {
        self.Title = Title
        self.Artist = Artist
        self.Album = Album
        self.AlbumART = AlbumART
        self.DateTracked = DateTracked
    }
}
