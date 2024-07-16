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
                        Image(uiImage: UIImage(data: song.AlbumART ?? Data()) ?? UIImage(systemName: "music.note")!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        Spacer()
                        VStack {
                            Text(song.Title).bold().font(.headline)
                            Text(song.Artist)
                            Text(song.Album)
                        }
                    }.frame(maxWidth: .infinity, maxHeight: 100)
                }
            }
        }
    }
}

#Preview {
    History()
}
