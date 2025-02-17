//
//  History.swift
//  ScratchThat
//
//  Created by Patryk Puciłowski on 13/07/2024.
//

import Foundation
import SwiftData
import SwiftUI

struct History: View {
    @Query(sort: \TrackedSongs.DateTracked, order: .reverse, animation: .smooth) private var songs: [TrackedSongs]
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(songs) { song in
                        Section(song.DateTracked.formatted(date: .abbreviated, time: .standard)) {
                            SongItem(songValues: song)
                        }
                    }
                }.listStyle(.plain)
            }.navigationTitle("Listening history")
        }
    }
}

#Preview {
    History()
}

struct SongItem: View {
    var songValues: TrackedSongs

    @State private var time: String = ""
    
    var body: some View {
        HStack {
            Image(uiImage: UIImage(data: songValues.AlbumART ?? Data()) ?? UIImage(systemName: "music.note")!)
                .resizable()
                .clipShape(.rect(cornerRadius: 10))
                .scaledToFit()
                .frame(width: 100, height: 100)
                .border(.accent)
            VStack(alignment: .leading) {
                HStack {
                    Text(songValues.Title).bold()
                    Spacer()
                    Text(time).fontDesign(.monospaced).foregroundStyle(.gray).font(.caption)
                }
                Text(songValues.Artist).foregroundStyle(.gray)
            }.multilineTextAlignment(.leading)
        }.frame(maxWidth: .infinity, maxHeight: 100).onTapGesture {
            time = formatTime(time: songValues.DateTracked)
        }.onAppear{
            time = formatTime(time: songValues.DateTracked)
        }
        // its cary to update date like that
        // ofc debug is having hangs
    }

    func formatTime(time: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full

        let formattedDate = formatter.localizedString(for: time, relativeTo: .now)

        return formattedDate
    }
}

#Preview("Individual song") {
    SongItem(songValues: TrackedSongs(Title: "Test", Artist: "Test artist", Album: "test", AlbumART: Data(), DateTracked: .now))
}
