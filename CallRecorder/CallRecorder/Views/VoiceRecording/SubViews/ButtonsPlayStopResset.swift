//
//  ButtonsPlayStopResset.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 06.09.2024.
//

import SwiftUI

struct ButtonsPlayStopResset: View {
    @ObservedObject var viewModel: VoiceRecordingViewModel
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                viewModel.timerIsRunning ? viewModel.stopTimer() : viewModel.startTimer()
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
              
            } label: {
                RoundedRectangle(cornerRadius: 24)
                    .frame(width: 64, height: 64)
                    .foregroundColor(.white)
                    .overlay {
                        Image(.resset)
                    }
            }
            Spacer()
        }
    }
}

#Preview {
    ButtonsPlayStopResset(viewModel: VoiceRecordingViewModel())
}
