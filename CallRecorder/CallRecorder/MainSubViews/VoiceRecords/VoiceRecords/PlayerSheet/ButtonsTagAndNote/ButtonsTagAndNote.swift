
import SwiftUI

struct ButtonsTagAndNote: View {
    @EnvironmentObject var audioPlayer: AudioPlayer
    @EnvironmentObject var audioRecorder: AudioRecorder
    @State private var showAddNoteAlert: Bool = false
    @State private var newNote: String = ""
    @ObservedObject var tagsNotes: TagsNotesManager
    
    var audioURL: URL
    @State private var showTagSheet: Bool = false
    
    var body: some View {
        HStack {
            Spacer()
           
            Button {
                showTagSheet = true
            } label: {
                VStack {
                    Image(.tag)
                    Text("Tag")
                        .foregroundColor(.primaryExtraDark.opacity(0.5))
                        .font(.system(size: 15, weight: .regular))
                }
            }
            
            Spacer()
            
            Button {
                showAddNoteAlert = true
            } label: {
                VStack {
                    Image(.note)
                    Text("Note")
                        .foregroundColor(.primaryExtraDark.opacity(0.5))
                        .font(.system(size: 15, weight: .regular))
                }
            }
            
            Spacer()
        }
        .alert("Add Note", isPresented: $showAddNoteAlert) {
            TextField("Placeholder", text: $newNote)
                .textInputAutocapitalization(.never)
            
            Button("Cancel", role: .cancel) { showAddNoteAlert = false }
            Button("Save", role: .none) {
                if !newNote.isEmpty && newNote.count <= 80 {
                    tagsNotes.notes.append(newNote)
                    audioRecorder.addNote(to: audioURL, note: newNote)
                    newNote = ""
                }
            }
            .disabled(newNote.count > 80)
            
        } message: {
            Text("\(newNote.count)/80 characters")
        }
        .sheet(isPresented: $showTagSheet) {
            TagSheet(audioURL: audioURL, tags: tagsNotes)
        }
    }
}

#Preview {
    ButtonsTagAndNote(tagsNotes: TagsNotesManager(), audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioRecorder())
}
