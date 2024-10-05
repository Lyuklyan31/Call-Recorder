import SwiftUI

struct PlayerSheet: View {
    
    @Binding var showMiniPlayer: Bool
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var audioPlayer: AudioPlayer
    @ObservedObject private var tagsNotesManager = TagsNotesManager()
    
    @Binding var audioURL: URL!
    
    @State private var isActive = false
    @State private var newName = ""
    @State private var originalName = ""

    @State private var recording: RecordingDataModel?
    
    var body: some View {
        let creationDate = getFileDate(for: audioURL)
        let formattedDate = creationDate?.formattedDate() ?? "Unknown date"
        NavigationStack {
            ZStack {
                MakeBackgroundView()
                
                VStack {
                    HStack {
                        ButtonPlayerDelete(audioURL: audioURL)
                        
                        ButtonPlayerShare(audioURL: audioURL)
                        
                        ButtonPlayerFavorite(audioURL: audioURL)
                        
                        Spacer()
                        
                        Button {
                            DispatchQueue.main.async {
                                showMiniPlayer = true
                            }
                            audioPlayer.resetPlayback()
                            dismiss()
                        } label: {
                            Image(.dismissButton)
                        }
                    }
                    .padding()
                    
                    VStack {
                        Text(formattedDate)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.primaryExtraDark.opacity(0.5))
                            .padding(8)
                        HStack {
                            Text(audioURL.deletingPathExtension().lastPathComponent)
                                .foregroundColor(.primary)
                                .font(.system(size: 24, weight: .semibold))
                            
                            Button {
                                originalName = audioURL.deletingPathExtension().lastPathComponent
                                newName = originalName
                                isActive.toggle()
                            } label: {
                                Image(.editingPencil)
                            }
                        }
                        
                        let notes = audioRecorder.notesForRecording(url: audioURL)
                        VStack {
                            if !notes.isEmpty {
                                HStack(spacing: 8) {
                                    ForEach(notes, id: \.self) { note in
                                        Text(note)
                                            .foregroundColor(.blue)
                                            .padding(.horizontal)
                                            
                                    }
                                }
                            }
                        }
                        
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
                    .padding(.top, 8)
                    
                    Player(audioURL: audioURL)
                        .padding()
                    
                    ButtonsTagAndNote(tagsNotes: tagsNotesManager, audioURL: audioURL)
                    Spacer()
                }
            }
            
            .onDisappear {
                audioPlayer.initializeAudioPlayer(with: audioURL)
                audioPlayer.resetPlayback()
            }
            
            
            .alert("Edit Name", isPresented: $isActive) {
                TextField("Placeholder", text: $newName)
                    .textInputAutocapitalization(.never)
                
                Button("Cancel", role: .cancel) { isActive = false }
                Button("Save", role: .none) { saveNewName() }
            } message: {
                Text("Enter a new name for this record")
            }
        }
    }
    private func saveNewName() {
        guard !newName.isEmpty, newName != originalName else { return }
        audioRecorder.renameRecording(oldURL: audioURL, newName: newName)
        audioURL = audioURL.deletingLastPathComponent()
                .appendingPathComponent(newName)
                .appendingPathExtension(audioURL.pathExtension)
    }
}
