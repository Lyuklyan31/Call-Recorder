//
//  VoiceRecordsView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 05.09.2024.
//

import SwiftUI

struct VoiceRecordsList: View {
    
    @State private var selection = 0
    
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
                    
                SegmnetVoiceRecords(selection: $selection)
                
                ButtonsAllWorkHome()
                
                RecordingsList(selection: $selection)
                    .navigationBarBackButtonHidden()
            }
        }
    }
}

#Preview {
    VoiceRecordsList()
        .environmentObject(AudioRecorder())
}
