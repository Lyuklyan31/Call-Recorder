//
//  VoiceRecordsView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 05.09.2024.
//

import SwiftUI

struct VoiceRecordsView: View {

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.backraundWhite, .backraundPink]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                NavigationBarSubView(title: "Voice Records")
                    
                SegmnetVoiceRecords()
                
                ButtonsAllWorkHome()
                
                RecordingsList()
                Spacer()
                    .navigationBarBackButtonHidden()
            }
        }
    }
}

#Preview {
    VoiceRecordsView()
        .environmentObject(AudioRecorder())
}
