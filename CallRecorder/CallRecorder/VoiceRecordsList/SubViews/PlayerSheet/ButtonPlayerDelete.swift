//
//  buttonDelete.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 11.09.2024.
//

import SwiftUI

struct ButtonPlayerDelete: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var audioRecorder: AudioRecorder
    var audioURL: URL

    var body: some View {
        Button {
            if let recording = audioRecorder.recordings.first(where: { $0.fileURL == audioURL }) {
                audioRecorder.deleteRecording(urlsToDelete: [recording.fileURL])
                dismiss()
            }
        } label: {
            Image(.trash)
        }
    }
}

#Preview {
    ButtonPlayerDelete(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioRecorder())
}
