//
//  PlayerView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 13.09.2024.
//

import SwiftUI

struct Player: View {
    @EnvironmentObject var audioPlayer: AudioPlayer
    var audioURL: URL
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .frame(height: 154)
                .foregroundColor(.white)
                .overlay {
                    VStack {
                        
                        Progress(audioURL: audioURL)
                        TimePlayerInterval(audioURL: audioURL)
                        ButtonsOfPlayer(audioURL: audioURL)
                        
                        Spacer()
                    }
                }
        }
    }
}

#Preview {
    Player(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioPlayer())
}
