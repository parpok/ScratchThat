//
//  Primary.swift
//  ScratchThat
//
//  Created by Patryk Puciłowski on 12/07/2024.
//

import OSLog
import SwiftData
import SwiftUI

struct MainScreen: View {
    @Environment(\.modelContext) private var ModelContext
    @State private var Music = MusicTracking(songTitle: "", author: "", albumName:  "")

    var body: some View {
        NavigationStack {
            VStack {
                switch !Music.songTitle.isEmpty {
                case true:
                    if let albumART = Music.albumArt {
                        Image(uiImage: albumART)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                    } else {
                        Image(systemName: "music.note")
                            .resizable()
                            .font(.largeTitle)
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                    }

                    Text(Music.songTitle)
                        .font(.title)
                        .bold()
                    Text(Music.author)
                        .font(.headline)

                case false:
                    Image(systemName: "music.note")
                        .resizable()
                        .font(.largeTitle)
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    Text("Nothing is playing right now")
                }
            }.navigationTitle("Now playing").navigationBarTitleDisplayMode(.large)
        }
        .onChange(of: Music.songTitle) {
            ModelContext.insert(TrackedSongs(Title: Music.songTitle, Artist: Music.author, Album: Music.albumName, AlbumART: Music.albumArt?.pngData(), DateTracked: Date.now))
            
            do{
                try ModelContext.save()
            } catch {
                print(error.localizedDescription)
            }
            os_log(.info, "Saving \(Music.songTitle) to the history")
        } // This should run in the background
    }
}

#Preview {
    HomeScreen()
}
