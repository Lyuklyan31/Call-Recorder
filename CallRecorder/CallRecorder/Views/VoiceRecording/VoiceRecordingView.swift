//
//  VoiceRecordingView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 06.09.2024.
//

import SwiftUI

struct VoiceRecordingView: View {
   
    @ObservedObject var viewModel = VoiceRecordingViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.backraundWhite, .backraundPink]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                NavigationBarSubView(title: "Voice Recording")
                    .padding(.bottom, 72)
                
                Text(viewModel.timeString)
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 24)
                
                Text("Recording from iPhone Microphone")
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
                    .padding(.bottom, 181)
                
                ZStack {
                    Waves()
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
}
