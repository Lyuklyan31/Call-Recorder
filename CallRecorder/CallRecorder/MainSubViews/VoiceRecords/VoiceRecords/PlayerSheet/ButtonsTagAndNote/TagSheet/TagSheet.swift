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
    @EnvironmentObject var audioPlayer: AudioPlayer
    
    var audioURL: URL
    
    @ObservedObject private var tags = TagsManager()
    
    @State private var tagHome = false
    @State private var tagWork = false
    @State private var choseTag = false
    @State private var newTag = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.backraundWhite, .backraundPink]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
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
                
                TagButton(chooseTag: $tagHome, title: "Home")
                TagButton(chooseTag: $tagWork, title: "Work")
                
                ForEach(tags.tags, id: \.self) { tag in
                    TagButton(chooseTag: $choseTag, title: tag)
                }
                
                CreateTagButton(newTag: $newTag) {
                    if !newTag.isEmpty && newTag.count <= 15 {
                        tags.tags.append(newTag)
                        print(tags)
                        newTag = ""
                    }
                }
                .padding()
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    TagSheet(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioRecorder())
}
