//
//  CallRecorderApp.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 03.09.2024.
//

import SwiftUI

@main
struct CallRecorderApp: App {
    var body: some Scene {
        WindowGroup {
            MainContentView()
                .environmentObject(AudioRecorder())
                .environmentObject(WavesViewModel())
                .environmentObject(AudioPlayer())
        }
    }
}
