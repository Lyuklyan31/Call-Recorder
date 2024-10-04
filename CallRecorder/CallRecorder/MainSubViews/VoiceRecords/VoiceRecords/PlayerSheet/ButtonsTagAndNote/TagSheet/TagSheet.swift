import SwiftUI

// MARK: - TagSheet View: UI for managing tags
struct TagSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var audioRecorder: AudioRecorder
    var audioURL: URL
    
    @ObservedObject private var tags = TagsManager()
    
    @State private var selectedTags: Set<String> = []
    @State private var newTag = ""
    
    var body: some View {
        ZStack {
            MakeBackgroundView()  // Custom background
            
            ScrollView {  // Wrap content in a ScrollView
                VStack {
                    
                    // MARK: - Header: Manage Tags Title and Dismiss Button
                    ZStack {
                        Text("Manage Tags")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.primaryExtraDark)
                        
                        HStack {
                            Spacer()
                            Button {
                                dismiss()  // Close the tag sheet
                            } label: {
                                Image(.dismissButton)
                            }
                        }
                    }
                    
                    // MARK: - Instructions
                    Text("You can pick up to 2 tags")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.primaryExtraDark.opacity(0.5))
                        .padding(.top, 32)
                        .padding(.bottom)
                    
                    // MARK: - Predefined Tags
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
                            if selectedTags.count < 2 {
                                selectedTags.insert("Work")
                                audioRecorder.addTag(to: audioURL, tag: "Work")
                            } else {
                                selectedTags.remove("Work")
                                audioRecorder.removeTag(from: audioURL, tag: "Work")
                            }
                        }
                    ), title: "Work", action: {})
                    
                    // MARK: - Dynamic Tags from TagsManager
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
                    
                    // MARK: - Add New Tag Button
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
                    // MARK: - Initialize Selected Tags
                    if let existingTags = audioRecorder.recordings.first(where: { $0.fileURL == audioURL })?.tags {
                        selectedTags = Set(existingTags)
                    }
                }
            }
        }
    }
}

#Preview {
    TagSheet(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioRecorder())
}
