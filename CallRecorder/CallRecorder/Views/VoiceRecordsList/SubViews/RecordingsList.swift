//
//  RecordingsList.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 07.09.2024.
//

import SwiftUI

struct RecordingsList: View {
    
    @EnvironmentObject var audioRecorder: AudioRecorder
    
    var body: some View {
        List {
            ForEach(Array(audioRecorder.recordings.enumerated()), id: \.element.createdAt) { index, recording in
                RecordingRow(audioURL: recording.fileURL, index: index + 1) // Передаємо порядковий номер
            }
            .onDelete(perform: delete)
        }
        .listStyle(PlainListStyle())
    }
    
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}

struct RecordingRow: View {
    
    var audioURL: URL
    var index: Int // Порядковий номер
    
    var body: some View {
        HStack {
            Image(.microphoneRec)
            VStack(alignment: .leading) {
                Text("Memo \(index)")
                Text("\(audioURL.lastPathComponent)")
            }
            Spacer()
        }
    }
}

#Preview {
    RecordingsList()
        .environmentObject(AudioRecorder())
}
