import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioRecorder: NSObject, ObservableObject {

    @Published var iCloudStore = false
    @Published var onMyPhonestore = false
    @Published var recordings = [RecordingDataModel]()
    @Published var recording = false

    var audioRecorder: AVAudioRecorder!

    override init() {
        super.init()
        fetchRecording()
    }

    func loadFavorites() {
        let savedFavorites = UserDefaults.standard.stringArray(forKey: "FavoriteRecordings") ?? []
        for urlString in savedFavorites {
            if let url = URL(string: urlString),
               let index = recordings.firstIndex(where: { $0.fileURL == url }) {
                recordings[index].isFavorite = true
            }
        }
    }

    func saveFavorites() {
        let favoriteURLs = recordings.filter { $0.isFavorite }.map { $0.fileURL.absoluteString }
        UserDefaults.standard.set(favoriteURLs, forKey: "FavoriteRecordings")
    }

    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }

        var documentPath: URL

        if iCloudStore {
            documentPath = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") ?? FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        } else {
            documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }

        let baseFileName = "Memo"
        let fileManager = FileManager.default
        var fileIndex = 1
        var audioFilename: URL
        var fileName: String

        repeat {
            if fileIndex == 0 {
                fileName = baseFileName
            } else {
                fileName = "\(baseFileName) \(fileIndex)"
            }

            audioFilename = documentPath.appendingPathComponent(fileName).appendingPathExtension("m4a")

            fileIndex += 1
        } while fileManager.fileExists(atPath: audioFilename.path)

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            recording = true
        } catch {
            print("Could not start recording")
        }
    }

    func fetchRecording() {
        recordings.removeAll()
        let fileManager = FileManager.default
        var documentDirectory: URL

        if iCloudStore {
            documentDirectory = fileManager.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") ?? fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        } else {
            documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }

        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            let creationDate = getFileDate(for: audio) ?? Date()
            let recording = RecordingDataModel(fileURL: audio, createdAt: creationDate)
            recordings.append(recording)
        }
        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending })
    }

    func resetRecording() {
        let fileManager = FileManager.default

        if recording {
            audioRecorder.stop()
            if audioRecorder.currentTime > 0 {
                let currentRecordingURL = audioRecorder.url
                do {
                    try fileManager.removeItem(at: currentRecordingURL)
                    print("File deleted: \(currentRecordingURL)")
                } catch {
                    print("Failed to delete file: \(error)")
                }
            }
            recording = false
            fetchRecording()
        }
    }

    func deleteRecording(urlsToDelete: [URL]) {
        let fileManager = FileManager.default
        for url in urlsToDelete {
            do {
                try fileManager.removeItem(at: url)
            } catch {
                print("File could not be deleted!")
            }
        }
        fetchRecording()
    }

    func stopRecording() {
        if audioRecorder.isRecording {
            audioRecorder.stop()
            recording = false
            fetchRecording()
        }
    }
    
    func renameRecording(oldURL: URL, newName: String) {
            let fileManager = FileManager.default

            guard !newName.isEmpty else {
                print("New name cannot be empty")
                return
            }

            let newURL = oldURL.deletingLastPathComponent()
                .appendingPathComponent(newName)
                .appendingPathExtension(oldURL.pathExtension)

            do {
                try fileManager.moveItem(at: oldURL, to: newURL)
                
                if let index = recordings.firstIndex(where: { $0.fileURL == oldURL }) {
                    recordings[index].fileURL = newURL
                    
                }
                
                print("File renamed to: \(newURL)")
            } catch {
                print("Failed to rename file: \(error)")
            }
        
        fetchRecording()
        }
}
