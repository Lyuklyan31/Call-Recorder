import SwiftUI
import AVFoundation

class WavesViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isActive = false
    @Published var amplitudeHistory: [CGFloat] = Array(repeating: 0.0, count: 100)
    
    // MARK: - Private Properties
    private var updateTimer: Timer?
    private var audioRecorder: AVAudioRecorder!
    private let smoothingFactor: CGFloat = 0.2
    private let scaleFactor: CGFloat = 2.2
    
    // MARK: - Monitoring Controls
    func startMonitoring() {
        isActive = true
        amplitudeHistory = Array(repeating: 0.0, count: 100)
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            audioRecorder = try AVAudioRecorder(url: getTemporaryFileURL(), settings: recordingSettings())
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()
            
            // Update amplitude history periodically
            updateTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                self.updateAmplitudeHistory()
            }
        } catch {
            print("Error setting up audio session: \(error)")
        }
    }

    func stopMonitoring() {
        isActive = false
        audioRecorder?.stop()
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    // MARK: - Amplitude History Update
    private func updateAmplitudeHistory() {
        audioRecorder.updateMeters()
        let level = audioRecorder.averagePower(forChannel: 0)
        let normalizedLevel = max(0.0, min(1.0, (level + 100) / 100))
        let scaledLevel = CGFloat(normalizedLevel) * scaleFactor
        let smoothedLevel = amplitudeHistory.last.map { smoothingFactor * scaledLevel + (1 - smoothingFactor) * $0 } ?? scaledLevel
        
        withAnimation(.linear(duration: 0.05)) {
            amplitudeHistory.append(smoothedLevel)
            if amplitudeHistory.count > 100 {
                amplitudeHistory.removeFirst()
            }
        }
    }
    
    // MARK: - Helper Methods
    private func getTemporaryFileURL() -> URL {
        FileManager.default.temporaryDirectory.appendingPathComponent("tempRecording.m4a")
    }
    
    private func recordingSettings() -> [String: Any] {
        [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
    }
}
