//
//  VoiceRecordingView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 06.09.2024.
//

import SwiftUI

struct VoiceRecordingView: View {
   
    @ObservedObject var viewModel = TimerViewModel()
    
    var body: some View {
        ZStack {
            MakeBackgroundView()
            
            VStack {
                NavigationBarSubView(title: "Voice Recording")
                    .padding(.bottom, 72)
                
                Text(viewModel.timeString)
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 24)
                
                Text(viewModel.timerIsRunning ? "Recording Paused" : "Recording from iPhone Microphone")
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
                    .padding(.bottom, 181)
                
                ZStack {
                    WaveView()
                    VStack {
                        Spacer()
                        ButtonsPlayStopResset(viewModel: viewModel)
                            .padding(.bottom)
                        
                    }
                }
                .navigationBarBackButtonHidden()
            }
        
        }
    }
}

#Preview {
    VoiceRecordingView()
        .environmentObject(AudioRecorder())
        .environmentObject(WavesViewModel())
}
