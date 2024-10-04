
import Foundation

// MARK: - TagsManager: Handles saving/loading tags
class TagsManager: ObservableObject {
    
    // MARK: - Singleton Instance
    static let shared = TagsManager()
    
    // MARK: - UserDefaults Key
    private let tagsKey = "savedTags"
    
    // MARK: - Published Tags Array
    @Published var tags: [String] = [] {
        didSet {
            saveTags()  // Automatically save when tags are updated
        }
    }
    
    // MARK: - Initializer: Load tags from storage
    init() {
        self.tags = loadTags()
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
