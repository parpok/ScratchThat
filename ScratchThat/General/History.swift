//
//  History.swift
//  ScratchThat
//
//  Created by Patryk Puciłowski on 13/07/2024.
//

import SwiftData
import SwiftUI

struct History: View {
    @Query(sort: \TrackedSongs.DateTracked, order: .reverse, animation: .smooth) private var songs: [TrackedSongs]
    var body: some View {
        NavigationStack {
            List {
                ForEach(songs) { song in
                    HStack {
                        if let albumArtData = song.AlbumART, let uiImage = UIImage(data: albumArtData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                        } else {
                            Image(systemName: "music.note")
                                .resizable()
                                .scaledToFit()
                        }
                        Spacer()
                        Text(song.Title)
                        Text(song.Artist)
                    }
                }
            }.navigationTitle("Listening history")
        }.listStyle(.plain)
    }
}

#Preview {
    History()
}
