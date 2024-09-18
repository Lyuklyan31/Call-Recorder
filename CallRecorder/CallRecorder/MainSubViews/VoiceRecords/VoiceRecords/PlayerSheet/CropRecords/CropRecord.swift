//
//  CropRecord.swift
//  CallRecorder
//
//  Created by Mac on 19.09.2024.
//

import SwiftUI

struct CropRecord: View {
    @EnvironmentObject var audioPlayer: AudioPlayer
    var audioURL: URL
    
    var body: some View {
        VStack {
            NavigationBarSubView(title: "Crop Record")
        }
    }
}

#Preview {
    CropRecord(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioPlayer())
}
