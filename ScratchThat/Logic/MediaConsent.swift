//
//  mediaConsent.swift
//  ScratchThat
//
//  Created by Patryk Puciłowski on 12/07/2024.
//

import Foundation
import MediaPlayer

@Observable
class MediaConsent {
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
