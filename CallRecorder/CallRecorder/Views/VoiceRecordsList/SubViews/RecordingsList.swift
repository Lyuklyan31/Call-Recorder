import SwiftUI

struct RecordingsList: View {
    
    @EnvironmentObject var audioRecorder: AudioRecorder
    @State private var selectedRecording: URL?
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            ForEach(Array(audioRecorder.recordings.enumerated()), id: \.element.createdAt) { index, recording in
                RecordingRow(audioURL: recording.fileURL, index: index + 1, selectedRecording: $selectedRecording, showSheet: $showSheet)
            }
            .onDelete(perform: delete)
        }
        .padding()
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

struct RecordingRow: View {
    
    var audioURL: URL
    var index: Int
    @Binding var selectedRecording: URL?
    @Binding var showSheet: Bool
    
    var body: some View {
        Button {
            selectedRecording = audioURL
        } label: {
            HStack {
                Image(.microphoneRec)
                VStack(alignment: .leading) {
                    Text("Memo \(index)")
                        .foregroundColor(.primary)
                    Text("\(audioURL.lastPathComponent)")
                        .padding(.bottom, 8)
                        .foregroundColor(.primaryExtraDark.opacity(0.5))
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.primary.opacity(0.5))
                }
                Spacer()
            }
        }
        .onChange(of: selectedRecording) { newValue in
            if newValue == audioURL {
                showSheet = true
            }
        }
    }
}



#Preview {
    RecordingsList()
        .environmentObject(AudioRecorder())
}
