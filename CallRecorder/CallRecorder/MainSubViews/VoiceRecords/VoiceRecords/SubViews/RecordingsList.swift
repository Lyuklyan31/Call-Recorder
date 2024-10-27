import SwiftUI

struct RecordingsList: View {
    
    // MARK: - Properties
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var audioPlayer: AudioPlayer
    @State private var selectedRecording: URL?
    @State private var showingPlayer = false
    @Binding var selection: Int
    @Binding var showMiniPlayer: Bool 
    
    @State private var selectedTags: Set<String> = ["All"]

    
    // MARK: - Body
    var body: some View {
        // Get filtered recordings based on selection and tags
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
                withAnimation {
                    self.selectedTags = tags
                }
            }
            
            if filteredRecordings.isEmpty {
                Spacer()
                emptyStateView()
                Spacer()
                Spacer()
            } else {
                // MARK: - Animated Recordings List
                List {
                    ForEach(filteredRecordings, id: \.fileURL) { recording in
                        RecordingRow(audioURL: recording.fileURL, selectedRecording: $selectedRecording, showSheet: $showingPlayer)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) { delete(recording: recording) } label: { Image(.trashForSwipe) }
                                ShareLink(item: recording.fileURL, preview: SharePreview(recording.fileURL.lastPathComponent, image: Image("microphone"))) {
                                    Image(.shareForSwipe)
                                }
                                .tint(.blue)
                            }
                    }
                    .transition(.opacity)
                }
                .listStyle(.plain)
                .modifier(
                    PairingSheet(
                        isShowing: $showingPlayer,
                        isExpandedByDefault: false,
                        defaultDetent: .medium,
                        title: "Pairing Sheet",
                        closeAction: {
                            DispatchQueue.main.async {
                                showMiniPlayer = true
                            }
                        },
                        sheetContent: {
                            PlayerSheet(showMiniPlayer: $showMiniPlayer, audioURL: $selectedRecording)
                        }
                    )
                )
                .onChange(of: selectedRecording) { newValue in
                    showingPlayer = newValue != nil
                }
            }
            
            if showMiniPlayer {
                ZStack {
                    MiniPlayerView(audioURL: $selectedRecording, showPlayerSheet: $showingPlayer)
                        .transition(.slide)
                }
            }
        }
        .animation(.easeInOut, value: selection)
    }
    
    // MARK: - Empty State View
    @ViewBuilder
    private func emptyStateView() -> some View {
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
    }
    
    // MARK: - Delete Function
    func delete(recording: RecordingDataModel) {
        audioRecorder.deleteRecording(urlsToDelete: [recording.fileURL])
        audioRecorder.fetchRecording()
    }
}
