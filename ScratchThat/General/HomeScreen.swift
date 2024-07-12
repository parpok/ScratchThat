//
//  HomeScreen.swift
//  ScratchThat
//
//  Created by Patryk Puciłowski on 12/07/2024.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        TabView {
            MainScreen().tabItem {
                Label("Home", systemImage: "house")
            }
        }
    }
}

#Preview {
    HomeScreen()
}