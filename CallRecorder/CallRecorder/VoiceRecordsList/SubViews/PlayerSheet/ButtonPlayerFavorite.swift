//
//  ButtonPlayerShare.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 13.09.2024.
//

import SwiftUI

struct ButtonPlayerFavorite: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    var audioURL: URL
    
    var body: some View {
        Button {
            if let index = audioRecorder.recordings.firstIndex(where: { $0.fileURL == audioURL }) {
                audioRecorder.recordings[index].isFavorite.toggle()
                audioRecorder.saveFavorites()
            }
        } label: {
            Image(audioRecorder.recordings.first(where: { $0.fileURL == audioURL })?.isFavorite ?? false ? .favoriteFill : .favorite)
        }
    }
}

#Preview {
    ButtonPlayerFavorite(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioRecorder())
}
