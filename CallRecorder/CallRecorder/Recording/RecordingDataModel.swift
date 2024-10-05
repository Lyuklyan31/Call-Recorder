import Foundation

struct RecordingDataModel {
    var fileURL: URL
    let createdAt: Date
    var isFavorite: Bool = false
    var tags: [String] = []
    
    var fileName: String {
        return fileURL.deletingPathExtension().lastPathComponent
    }
}
