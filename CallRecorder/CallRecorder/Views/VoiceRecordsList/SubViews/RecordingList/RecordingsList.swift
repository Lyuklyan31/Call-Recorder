import SwiftUI

struct RecordingsList: View {
    
    @EnvironmentObject var audioRecorder: AudioRecorder
    @State private var selectedRecording: URL?
    @State private var showSheet = false
    
    var body: some View {
        List {
            ForEach(audioRecorder.recordings.indices, id: \.self) { index in
                let recording = audioRecorder.recordings[index]
                RecordingRow(audioURL: recording.fileURL, selectedRecording: $selectedRecording, showSheet: $showSheet)
                
                    .swipeActions(edge: .trailing) {
                        ButtonDelete(action: {
                            delete(at: IndexSet(integer: index))
                        })
                        ShareLink(item: recording.fileURL, preview: SharePreview(recording.fileURL.lastPathComponent, image: Image("microphone"))) {
                            Image(.shareForSwipe)
                        }
                        .tint(.blue)
                    }
            }
        }
        .listStyle(.plain)
        .sheet(isPresented: $showSheet) {
            if let selectedRecording = selectedRecording {
                RecordingDetailsSheet(audioURL: selectedRecording)
                    .presentationDetents([.fraction(0.12)])
            }
        }
        .onChange(of: selectedRecording) { newValue in
            showSheet = newValue != nil
        }
    }
    
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}


import SwiftUI

struct RecordingRow: View {
    
    var audioURL: URL
    
    @Binding var selectedRecording: URL?
    @Binding var showSheet: Bool
    
    @State private var audioDuration: String = "00:00"
    
    var body: some View {
        let creationDate = getFileDate(for: audioURL)
        let formattedDate = creationDate?.formattedDate() ?? "Unknown date"
        
        Button {
            selectedRecording = audioURL
        } label: {
            HStack {
                Image(.microphoneRec)
                VStack(alignment: .leading) {
                    Text(audioURL.deletingPathExtension().lastPathComponent)
                        .foregroundColor(.primary)
                        .font(.system(size: 17, weight: .regular))
                    Text(formattedDate)
                        .padding(.bottom, 8)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.primaryExtraDark.opacity(0.5))
                }
                
                Spacer()
                Text(audioDuration)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
            }
        }
        .onChange(of: selectedRecording) { newValue in
            if newValue == audioURL {
                showSheet = true
            }
        }
        .onAppear {
            AudioPlayer.getAudioDuration(url: audioURL) { duration in
                let minutes = Int(duration) / 60
                let seconds = Int(duration) % 60
                audioDuration = String(format: "%02d:%02d", minutes, seconds)
            }
        }
    }
}

#Preview {
    RecordingsList()
        .environmentObject(AudioRecorder())
}
