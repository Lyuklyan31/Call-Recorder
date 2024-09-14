//
//  ButtonShare.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 13.09.2024.
//

import SwiftUI

struct ButtonPlayerShare: View {
    var audioURL: URL
    var body: some View {
        ShareLink(item: audioURL, preview: SharePreview(audioURL.lastPathComponent, image: Image("microphone"))) {
            Image(.share)
        }
    }
}

#Preview {
    ButtonPlayerShare(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioRecorder())
}
