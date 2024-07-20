//
//  MusicTracking.swift
//  ScratchThat
//
//  Created by Patryk Puciłowski on 12/07/2024.
//

import BackgroundTasks
import Foundation
import MediaPlayer
import OSLog
import SwiftData

@Observable
class MusicTracking {
    var albumArt: UIImage?
    var songTitle: String
    var author: String
    var albumName: String

    let musicPlayer = MPMusicPlayerController.systemMusicPlayer

    /// Make an Event Listener to listen to the event. But it wont work without getting the selected function running.
    func recordPlaying() {
        musicPlayer.beginGeneratingPlaybackNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(updateSong), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: musicPlayer)
        os_log("Recording media playback", type: .info)

        updateSong()
    }

    /// Run this gagatek and that Event listener for media content will work.
    @objc func updateSong() {
        if let nowPlayingItem = musicPlayer.nowPlayingItem {
            albumArt = (nowPlayingItem.artwork?.image(at: CGSize(width: 100, height: 100))) /* ?? UIImage(systemName: "music.note")! */
            // this SF Symbol for music note is only so when it compiles and the
            songTitle = nowPlayingItem.title ?? ""
            author = nowPlayingItem.artist ?? ""
            albumName = nowPlayingItem.albumTitle ?? ""

            os_log("Playing \(self.songTitle)")
        } else {
            os_log(.error, "Nothing is playing right now")
        }
    }

    /// Stop recording media playback
    func stopRecording() {
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: musicPlayer)
        musicPlayer.endGeneratingPlaybackNotifications()
        songTitle = ""
        author = ""
        albumName = ""
        albumArt = nil

        os_log("Stopped checking for playback notifications", type: .info)
    }

    /// Register background task for posting content
//    func registerBGTaskPost() {
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "xyz.parpok.ScratchThat.pushToLFM", using: .main) { _ in
//            os_log("This should post to Last.fm on the background rn", type: .debug)
//        }
//
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "xyz.parpok.ScratchThat.pushToDSC", using: .main) { _ in
//            os_log("This should post to Discord in the background rn", type: .debug)
//        }
//    }

    init(albumArt: UIImage? = nil, songTitle: String, author: String, album: String) {
        self.albumArt = albumArt
        self.songTitle = songTitle
        self.author = author
        albumName = album

        recordPlaying()
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
