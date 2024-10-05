import Foundation

// MARK: - TagsNotesManager: Handles saving/loading tags and notes
class TagsNotesManager: ObservableObject {
    
    // MARK: - Singleton Instance
    static let shared = TagsNotesManager()
    
    // MARK: - UserDefaults Keys
    private let notesKey = "savedNotes"
    private let tagsKey = "savedTags"
    
    // MARK: - Published Notes Array
    @Published var notes: [String] = [] {
        didSet {
            saveNotes()
        }
    }
    
    // MARK: - Published Tags Array
    @Published var tags: [String] = [] {
        didSet {
            saveTags()
        }
    }
    
    // MARK: - Initializer: Load notes and tags from storage
    init() {
        self.notes = loadNotes()
        self.tags = loadTags()
    }
    
    // MARK: - Save Notes
    private func saveNotes() {
        UserDefaults.standard.set(notes, forKey: notesKey)
    }
    
    // MARK: - Load Notes
    private func loadNotes() -> [String] {
        return UserDefaults.standard.stringArray(forKey: notesKey) ?? []
    }
    
    // MARK: - Save Tags
    private func saveTags() {
        UserDefaults.standard.set(tags, forKey: tagsKey)
    }
    
    // MARK: - Load Tags
    private func loadTags() -> [String] {
        return UserDefaults.standard.stringArray(forKey: tagsKey) ?? []
    }
}
