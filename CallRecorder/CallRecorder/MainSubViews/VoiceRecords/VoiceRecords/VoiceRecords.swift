//
//  VoiceRecordsView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 05.09.2024.
//

import SwiftUI

struct VoiceRecords: View {
    
    @State private var selection = 0
    @State private var selectionTag = 0
    
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
                
                ButtonsAllWorkHome(selectedButton: selectionTag)
                
                RecordingsList(selection: $selection)
                    .navigationBarBackButtonHidden()
            }
        }
    }
}

#Preview {
    VoiceRecords()
        .environmentObject(AudioRecorder())
        .environmentObject(AudioPlayer())
}
