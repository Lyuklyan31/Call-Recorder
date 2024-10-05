
import Foundation

// MARK: - TagsManager: Handles saving/loading tags
class TagsNotesManager: ObservableObject {
    
    // MARK: - Singleton Instance
    static let shared = TagsNotesManager()
    
    // MARK: - UserDefaults Key
    private let notesKey = "savedTags"
    
    // MARK: - Published Tags Array
    @Published var notes: [String] = [] {
        didSet {
            saveNote()
        }
    }
    
    // MARK: - Initializer: Load tags from storage
    init() {
        self.notes = loadTags()
        self.tags = loadTags()
    }
    
    // MARK: - Save
    private func saveNote() {
        UserDefaults.standard.set(notes, forKey: notesKey)
    }
    
    // MARK: - Load
    private func loadNotes() -> [String] {
        return UserDefaults.standard.stringArray(forKey: notesKey) ?? []
    }
    
    
    // MARK: - UserDefaults Key
    private let tagsKey = "savedTags"
    
    // MARK: - Published Array
    @Published var tags: [String] = [] {
        didSet {
            saveTags()
        }
    }
    
    // MARK: - Save
    private func saveTags() {
        UserDefaults.standard.set(tags, forKey: tagsKey)
    }
    
    // MARK: - Load
    private func loadTags() -> [String] {
        return UserDefaults.standard.stringArray(forKey: tagsKey) ?? []
    }
}
