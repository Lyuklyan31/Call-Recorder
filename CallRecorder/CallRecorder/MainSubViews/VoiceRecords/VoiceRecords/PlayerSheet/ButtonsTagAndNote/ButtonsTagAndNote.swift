
import SwiftUI

struct ButtonsTagAndNote: View {
    @EnvironmentObject var audioPlayer: AudioPlayer
    @State private var showAddNoteAlert: Bool = false
    @State private var noteText: String = ""
    @ObservedObject private var tags = TagsNotesManager()
    
    var audioURL: URL
    @Binding var showTagSheet: Bool
    
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
            TextField("Placeholder", text: $noteText)
                .textInputAutocapitalization(.never)
            
            Button("Cancel", role: .cancel) { showAddNoteAlert = false }
            Button("Save", role: .none) {
                if !noteText.isEmpty && noteText.count <= 80 {
//                    tags.tags.append(newTag)
//                    newTag = ""
                }
            }
            
        } message: {
            Text("\(noteText.count)/80 characters")
        }
    }
}

#Preview {
    ButtonsTagAndNote(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!, showTagSheet: .constant(false))
        .environmentObject(AudioRecorder())
}
