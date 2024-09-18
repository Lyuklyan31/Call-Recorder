import SwiftUI

class TagsManager: ObservableObject {
    
    static let shared = TagsManager()
    
    private let tagsKey = "savedTags"
    
    @Published var tags: [String] = [] {
        didSet {
            saveTags()
        }
    }
    
    init() {
        self.tags = loadTags()
    }
    
    private func saveTags() {
        UserDefaults.standard.set(tags, forKey: tagsKey)
    }
    
    private func loadTags() -> [String] {
        return UserDefaults.standard.stringArray(forKey: tagsKey) ?? []
    }
}



struct TagSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var audioRecorder: AudioRecorder
    var audioURL: URL
    
    @ObservedObject private var tags = TagsManager()
    
    @State private var selectedTags: Set<String> = []
    
    @State private var newTag = ""
    
    var body: some View {
        ZStack {
            MakeBackgroundView()
            
            VStack {
                ZStack {
                    Text("Manage Tags")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.primaryExtraDark)
                    
                    HStack {
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(.dismissButton)
                        }
                    }
                }
                
                Text("You can pick up to 2 tags")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
                    .padding(.top, 32)
                    .padding(.bottom)
                
                TagButton(isSelected: Binding(
                    get: { selectedTags.contains("Home") },
                    set: { isSelected in
                        if isSelected {
                            if selectedTags.count < 2 {
                                selectedTags.insert("Home")
                                audioRecorder.addTag(to: audioURL, tag: "Home")
                            }
                        } else {
                            selectedTags.remove("Home")
                            audioRecorder.removeTag(from: audioURL, tag: "Home")
                        }
                    }
                ), title: "Home", action: {})
                
                TagButton(isSelected: Binding(
                    get: { selectedTags.contains("Work") },
                    set: { isSelected in
                        if isSelected {
                            if selectedTags.count < 2 {
                                selectedTags.insert("Work")
                                audioRecorder.addTag(to: audioURL, tag: "Work")
                            }
                        } else {
                            selectedTags.remove("Work")
                            audioRecorder.removeTag(from: audioURL, tag: "Work")
                        }
                    }
                ), title: "Work", action: {})
                
                ForEach(tags.tags, id: \.self) { tag in
                    TagButton(isSelected: Binding(
                        get: { selectedTags.contains(tag) },
                        set: { isSelected in
                            if isSelected {
                                if selectedTags.count < 2 {
                                    selectedTags.insert(tag)
                                    audioRecorder.addTag(to: audioURL, tag: tag)
                                }
                            } else {
                                selectedTags.remove(tag)
                                audioRecorder.removeTag(from: audioURL, tag: tag)
                            }
                        }
                    ), title: tag, action: {})
                }
                
                CreateTagButton(newTag: $newTag) {
                    if !newTag.isEmpty && newTag.count <= 15 {
                        tags.tags.append(newTag)
                        newTag = ""
                    }
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .onAppear {
                // Initialize selectedTags based on existing tags for the audio URL
                if let existingTags = audioRecorder.recordings.first(where: { $0.fileURL == audioURL })?.tags {
                    selectedTags = Set(existingTags)
                }
            }
        }
    }
}

#Preview {
    TagSheet(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioRecorder())
}
