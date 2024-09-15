//
//  ButtonTag.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 14.09.2024.
//

import SwiftUI

struct ButtonsTagAndNote: View {
    @EnvironmentObject var audioPlayer: AudioPlayer
    var audioURL: URL
    @Binding var showTagSheet: Bool
    
    var body: some View {
        HStack {
            Spacer()
           
            Button {
                showTagSheet = true
            } label: {
                VStack {
                    Image(.tag)
                    Text("Tag")
                        .foregroundColor(.primaryExtraDark.opacity(0.5))
                        .font(.system(size: 15, weight: .regular))
                }
            }
            
            Spacer()
            
            Button {
                
            } label: {
                VStack {
                    Image(.note)
                    Text("Note")
                        .foregroundColor(.primaryExtraDark.opacity(0.5))
                        .font(.system(size: 15, weight: .regular))
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    ButtonsTagAndNote(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!, showTagSheet: .constant(false))
        .environmentObject(AudioRecorder())
}
