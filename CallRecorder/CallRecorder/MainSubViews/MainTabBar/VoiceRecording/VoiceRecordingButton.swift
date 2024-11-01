//
//  RecordButtonSubView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 04.09.2024.
//

import SwiftUI

struct VoiceRecordingButton: View {
    var body: some View {
        NavigationLink {
            ChoosingStorage()
        } label: {
            ZStack {
                Circle()
                    .frame(width: 240)
                    .foregroundColor(.customPink.opacity(0.1))
                    .blur(radius: 1.2)
                    .shadow(radius: 2)
                
                Circle()
                    .frame(width: 192)
                    .foregroundColor(.customPink.opacity(0.1))
                    .blur(radius: 1.2)
                    .shadow(radius: 2)
                
                Circle()
                    .frame(width: 142)
                    .foregroundColor(.white)
                
                Image(.microphone)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            }
        }
    }
}

#Preview {
    VoiceRecordingButton()
}
