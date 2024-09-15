import SwiftUI

struct PlayerSheet: View {
    
    @Binding var showSheet: Bool
    @State private var showTagSheet = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var audioPlayer: AudioPlayer
    
    var audioURL: URL
    
    @State private var isActive = false
    @State private var newName = ""
    @State private var originalName = ""

    var body: some View {
        let creationDate = getFileDate(for: audioURL)
        let formattedDate = creationDate?.formattedDate() ?? "Unknown date"
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.backraundWhite, .backraundPink]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    ButtonPlayerDelete(audioURL: audioURL)
                    
                    ButtonPlayerShare(audioURL: audioURL)
                    
                    ButtonPlayerFavorite(audioURL: audioURL)
                    
                    Spacer()
                    
                    Button {
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
                }
                .padding(.top, 8)
                
                Player(audioURL: audioURL)
                    .padding()
                
                ButtonsTagAndNote(audioURL: audioURL, showTagSheet: $showTagSheet)
                Spacer()
            }
        }
        .sheet(isPresented: $showTagSheet) {
            TagSheet(audioURL: audioURL)
        }
        
        .onTapGesture {
            dismiss()
        }
        .onDisappear {
            audioPlayer.resetPlayback()
        }
        .alert("Edit Name", isPresented: $isActive) {
            TextField("Placeholder", text: $newName)
                .textInputAutocapitalization(.never)
            
            Button("Cancel", role: .cancel) { }
            Button("Save", role: .none) {
                saveNewName()
            }
        } message: {
            Text("Enter a new name for this record")
        }
    }
    
    private func saveNewName() {
        guard !newName.isEmpty, newName != originalName else { return }
        audioRecorder.renameRecording(oldURL: audioURL, newName: newName)
        showSheet = false
        dismiss()
    }
}


#Preview {
    PlayerSheet(showSheet: .constant(false), audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioRecorder())
        .environmentObject(AudioPlayer())
}


