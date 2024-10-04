//
//  VoiceRecordsView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 05.09.2024.
//

import SwiftUI

struct VoiceRecords: View {
    @State var showMiniPlayer: Bool = false
    @State private var selection = 0
    
    var body: some View {
        ZStack {
            MakeBackgroundView()
                
            VStack {
                NavigationBarSubView(title: "Voice Records")
                    
                SegmentVoiceRecords(selection: $selection)
                   
                RecordingsList(selection: $selection, showMiniPlayer: $showMiniPlayer)
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
