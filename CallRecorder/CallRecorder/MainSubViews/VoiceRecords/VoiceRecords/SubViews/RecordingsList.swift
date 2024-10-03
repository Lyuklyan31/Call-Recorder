import SwiftUI

struct RecordingsList: View {
    
    // MARK: - Properties
    @EnvironmentObject var audioRecorder: AudioRecorder
    @State private var selectedRecording: URL?
    @State private var showSheet = false
    @Binding var selection: Int
    @State private var selectedTags: Set<String> = ["All"]
    
    // MARK: - Body
    var body: some View {
        let recordings = selection == 1
            ? audioRecorder.recordings.filter { $0.isFavorite }
            : audioRecorder.recordings
        
        let filteredRecordings = recordings.filter { recording in
            if selectedTags.contains("All") {
                return true
            }
            return !selectedTags.isDisjoint(with: Set(recording.tags))
        }
        
        VStack {
            // MARK: - Tag Selection
            ChoosingTagButtons { tags in
                self.selectedTags = tags
            }
            
            if filteredRecordings.isEmpty {
                Spacer()
                
                // MARK: - Empty State
                if selection == 0 {
                    Image(.microphoneForIsEmpty)
                        .padding(.bottom, 16)
                    Text("You have no Starred Records")
                        .font(.system(size: 19, weight: .medium))
                        .padding(.bottom, 4)
                    Text("Star recordings to display them in this section")
                        .foregroundColor(.primaryExtraDark.opacity(0.5))
                        .font(.system(size: 15, weight: .regular))
                } else {
                    Image(.phoneForIsEmpty)
                        .padding(.bottom, 16)
                    Text("You have no Records")
                        .font(.system(size: 19, weight: .medium))
                        .padding(.bottom, 4)
                    Text("Records will appear here after calls are made")
                        .foregroundColor(.primaryExtraDark.opacity(0.5))
                        .font(.system(size: 15, weight: .regular))
                }
                Spacer()
                Spacer()
            } else {
                // MARK: - Recordings List
                List {
                    ForEach(filteredRecordings, id: \.fileURL) { recording in
                        RecordingRow(audioURL: recording.fileURL, selectedRecording: $selectedRecording, showSheet: $showSheet)
                            .swipeActions(edge: .trailing) {
                                ButtonDelete(action: {
                                    delete(recording: recording)
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
                        MiniPlayerView(audioURL: selectedRecording)
                            .presentationDetents([.fraction(0.12)])
                            .onDisappear {
                                self.selectedRecording = nil
                            }
                    }
                }
                .onChange(of: selectedRecording) { newValue in
                    print(selectedRecording as Any)
                    showSheet = newValue != nil
                }
//                .onChange(of: showSheet) { newValue in
//                    if !newValue {
//                        selectedRecording = nil
//                    }
//                }
            }
        }
    }
    
    // MARK: - Delete Function
    func delete(recording: RecordingDataModel) {
        audioRecorder.deleteRecording(urlsToDelete: [recording.fileURL])
        audioRecorder.fetchRecording()
    }
}

// MARK: - RecordingRow
struct RecordingRow: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    var audioURL: URL
    
    @Binding var selectedRecording: URL?
    @Binding var showSheet: Bool
    
    @State private var audioDuration: String = "00:00"
    
    // MARK: - Body
    var body: some View {
        let creationDate = getFileDate(for: audioURL)
        let formattedDate = creationDate?.formattedDate() ?? "Unknown date"
       
        let isFavorite = audioRecorder.recordings.first(where: { $0.fileURL == audioURL })?.isFavorite ?? false
        
        Button {
            selectedRecording = audioURL
        } label: {
            HStack {
                Image(.microphoneRec)
                    .padding(.trailing, 8)
                VStack(alignment: .leading) {
                    HStack {
                        Text(audioURL.deletingPathExtension().lastPathComponent)
                            .foregroundColor(.primary)
                            .font(.system(size: 17, weight: .regular))
                    }
                    
                    Text(formattedDate)
                        .padding(.bottom, 2)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.primaryExtraDark.opacity(0.5))
                    
                    let tags = audioRecorder.tagsForRecording(url: audioURL)
                    VStack {
                        if !tags.isEmpty {
                            HStack(spacing: 8) {
                                ForEach(tags, id: \.self) { tag in
                                    Text(tag)
                                        .padding(.horizontal)
                                        .padding(.vertical, 4)
                                        .background(Capsule().foregroundColor(.customPink.opacity(0.1)))
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                if isFavorite {
                    Image(.favoriteFill)
                        .foregroundColor(.yellow)
                }
                
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

// MARK: - Preview
#Preview {
    RecordingsList(selection: .constant(0))
        .environmentObject(AudioRecorder())
        .environmentObject(AudioPlayer())
}
