//
//  ButtonsPlayStopResset.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 06.09.2024.
//

import SwiftUI

struct ButtonsPlayStopResset: View {
    @ObservedObject var viewModel: TimerViewModel
    
    @EnvironmentObject var wavesViewModel: WavesViewModel
    @EnvironmentObject var audioRecorder: AudioRecorder
    
    @State private var showingAlert = false
    var body: some View {
        HStack {
            Spacer()
            Button {
                if viewModel.timerIsRunning == true {
                    audioRecorder.stopRecording()
                    wavesViewModel.stopMonitoring()
                    viewModel.stopTimer()
                    viewModel.resetTimer()
                } else {
                    audioRecorder.startRecording()
                    wavesViewModel.startMonitoring()
                    viewModel.startTimer()
                }
             
            } label: {
                RoundedRectangle(cornerRadius: 24)
                    .frame(width: 64, height: 64)
                    .foregroundColor(.white)
                    .overlay {
                        viewModel.timerIsRunning ? Image(.stop) : Image(.play)
                    }
            }
           
            Spacer()
          
            Button {
                viewModel.resetTimer()
                audioRecorder.resetRecording()
                showingAlert = true
            } label: {
                RoundedRectangle(cornerRadius: 24)
                    .frame(width: 64, height: 64)
                    .foregroundColor(.white)
                    .overlay {
                        Image(.resset)
                    }
            }
            .disabled(viewModel.timerIsRunning == false)
            Spacer()
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Cancel Recording?"),
                message: Text("Cancelling the recording will discard any unsaved data. Continue?"),
                primaryButton: .destructive(Text("Cancel")) {
                    wavesViewModel.stopMonitoring()
                    audioRecorder.resetRecording()
                },
                secondaryButton: .cancel(Text("Back")) {
                   
                }
            )
        }

    }
}

#Preview {
    ButtonsPlayStopResset(viewModel: TimerViewModel())
        .environmentObject(AudioRecorder())
        .environmentObject(WavesViewModel())
}
