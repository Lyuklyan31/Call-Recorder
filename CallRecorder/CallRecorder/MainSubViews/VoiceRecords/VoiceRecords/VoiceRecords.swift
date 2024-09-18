//
//  VoiceRecordsView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 05.09.2024.
//

import SwiftUI

struct VoiceRecords: View {
    
    @State private var selection = 0
    
    var body: some View {
        ZStack {
            MakeBackgroundView()
            
            VStack {
                NavigationBarSubView(title: "Voice Records")
                    
                SegmnetVoiceRecords(selection: $selection)
                
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
