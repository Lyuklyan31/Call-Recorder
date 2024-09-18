import Foundation

struct RecordingDataModel {
    var fileURL: URL
    let createdAt: Date
    var isFavorite: Bool = false
    var tags: [String] = []
    
    var fileName: String {
        return fileURL.deletingPathExtension().lastPathComponent
    }
    
    mutating func addTag(_ tag: String) {
        if !tags.contains(tag) {
            tags.append(tag)
        }
    }
}
