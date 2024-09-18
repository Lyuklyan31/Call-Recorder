//
//  ButtonsOfPlayer.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 13.09.2024.
//

import SwiftUI

struct ButtonsOfPlayer: View {
    @EnvironmentObject var audioPlayer: AudioPlayer
    var audioURL: URL
    
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Text("1x")
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
                    .font(.system(size: 17, weight: .regular))
                
            }
            .padding()
            
            Spacer()
            
            Button {
                
            } label: {
                Image(.backButton10Sec)
            }
            .padding()
            
            Button {
                if audioPlayer.isPlaying {
                    self.audioPlayer.pausePlayback()
                } else {
                    self.audioPlayer.startPlayback(audio: self.audioURL)
                }
            } label: {
                if audioPlayer.isPlaying {
                    Image(.buttonStopForPlayer)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                } else {
                    Image(.buttonPlayForPlayer)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                }
            }
            
            Button {
                
            } label: {
                Image(.forvardButton10Sec)
            }
            .padding()
            
            
            Spacer()
            
            NavigationLink {
                CropRecord(audioURL: audioURL)
            } label: {
                Image(.scisor)
            }
            .padding(.trailing)
            
         
        }
        .padding(.top, 8)
        .padding(.horizontal)
    }
}

#Preview {
    ButtonsOfPlayer(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioPlayer())
}
