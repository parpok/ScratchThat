//
//  ContentView.swift
//  ScratchThat
//
//  Created by Patryk Puciłowski on 06/07/2024.
//

import MediaPlayer
import SwiftUI

struct ContentView: View {
    @State private var stuff = MusicTracking(albumArt: UIImage(systemName: "music.note")!, songTitle: "", author: "", album: "")
    @State private var consent = MediaConsent()
    var body: some View {
        NavigationStack {
            switch consent.consent {
            case .authorized:
                HomeScreen()
            case .notDetermined:
                // Separate views breaks it unless the consent is bindable
                VStack {
                    Text("Welcome to ScratchThat")
                        .font(.title)
                        .bold()

                    Text("This app requires media usage. Please provide permission.")
                        .multilineTextAlignment(.center)

                    Button {
                        consent.requestConsent()
                    } label: {
                        Label {
                            Text("Provide permission")
                        } icon: {
                            Image(systemName: "checkmark")
                        }
                    }.buttonStyle(.borderedProminent)
                }.padding().onAppear {
                    consent.consent = MPMediaLibrary.authorizationStatus()
                }

            case .denied:
                NotOKView()
            case .restricted:
                NotOKView()
            @unknown default:
                fatalError("UNKNOWN AUTHORIZATION STATUS")
            }
        }.onChange(of: consent.consent) {
            print("UPDAATE UI")
        }
    }
}

#Preview {
    ContentView()
}

struct NotOKView: View {
    var body: some View {
        ContentUnavailableView("No media permission", systemImage: "exclamationmark.octagon.fill", description: Text("To use this app you need to provide media library permission"))

        Button(action: {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }) {
            Text("Provide permission in settings")
        }
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
        .padding()
    }
}

#Preview("Permission denied/Restricted") {
    NotOKView()
}
