import SwiftUI
import AVFoundation

class WavesViewModel: ObservableObject {
    
    @Published var isActive = false
    private var updateTimer: Timer?
    @Published var amplitudeHistory: [CGFloat] = Array(repeating: 0.0, count: 100)

    var audioRecorder: AVAudioRecorder!
    private var smoothingFactor: CGFloat = 0.2 // Lower smoothing factor for more sensitivity
    private var scaleFactor: CGFloat = 2.2 // Scale factor to make peaks more pronounced

    func startMonitoring() {
        isActive = true
        amplitudeHistory = Array(repeating: 0.0, count: 100)
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)

            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: getTemporaryFileURL(), settings: settings)
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()

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

    func updateAmplitudeHistory() {
        audioRecorder.updateMeters()
        let level = audioRecorder.averagePower(forChannel: 0)
        let normalizedLevel = max(0.0, min(1.0, (level + 100) / 100))
        let scaledLevel = CGFloat(normalizedLevel) * scaleFactor // Apply scaling for pronounced peaks
        let smoothedLevel = amplitudeHistory.last.map { smoothingFactor * scaledLevel + (1 - smoothingFactor) * $0 } ?? scaledLevel
        
        withAnimation(.linear(duration: 0.05)) {
            amplitudeHistory.append(smoothedLevel)
            if amplitudeHistory.count > 100 {
                amplitudeHistory.removeFirst()
            }
        }
    }
    
    func getTemporaryFileURL() -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        return tempDir.appendingPathComponent("tempRecording.m4a")
    }
}
