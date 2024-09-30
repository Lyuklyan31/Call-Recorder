import Foundation
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    // MARK: - Published Properties
    @Published var isPlaying = false
    @Published var isPaused = false
    @Published var progress: Double = 0.0
    
    // MARK: - Private Properties
    var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    var duration: TimeInterval {
        audioPlayer?.duration ?? 0
    }
    
    // MARK: - Initializer
    override init() {
        super.init()
    }
    
    // MARK: - Timer Management
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.updateProgress()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Playback Control
    func initializeAudioPlayer(with audio: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            print("Audio player initialized and ready to play.")
        } catch let error {
            print("Failed to initialize audio player with error: \(error.localizedDescription)")
        }
    }

    func startPlayback(audio: URL) {
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.setCategory(.playback, mode: .default, options: [])
            try playbackSession.setActive(true)
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch let error {
            print("Audio session setup failed with error: \(error.localizedDescription)")
        }
        
        do {
            if let player = audioPlayer {
                player.play()
            } else {
                audioPlayer = try AVAudioPlayer(contentsOf: audio)
                audioPlayer?.delegate = self
                audioPlayer?.play()
            }
            isPlaying = true
            isPaused = false
            startTimer()
        } catch let error {
            print("Playback failed with error: \(error.localizedDescription)")
        }
    }

    func pausePlayback() {
        audioPlayer?.pause()
        isPlaying = false
        isPaused = true
        stopTimer()
    }

    func stopPlayback() {
        audioPlayer?.stop()
        isPlaying = false
        isPaused = false
        stopTimer()
        progress = 0.0
    }

    func resetPlayback() {
        stopPlayback()
        progress = 0.0
        audioPlayer?.currentTime = 0
    }

    func seekForward(seconds: TimeInterval = 10) {
        guard let player = audioPlayer else { return }
        let newTime = player.currentTime + seconds
        player.currentTime = min(newTime, player.duration)
    }

    func seekBack(seconds: TimeInterval = 10) {
        guard let player = audioPlayer else { return }
        let newTime = player.currentTime - seconds
        player.currentTime = max(newTime, 0)
    }

    // MARK: - Playback Information
    func currentTime() -> String {
        guard let player = audioPlayer else {
            return "00:00"
        }
        let currentTime = Int(player.currentTime)
        let minutes = currentTime / 60
        let seconds = currentTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func remainingTime() -> String {
        guard let player = audioPlayer else { return "00:00" }
        let remaining = player.duration - player.currentTime
        let minutes = Int(remaining) / 60
        let seconds = Int(remaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func updateProgress() {
        guard let player = audioPlayer else { return }
        progress = player.currentTime / player.duration
    }

    // MARK: - Update Current Time
    func updateCurrentTime(with offset: CGFloat, maxWidth: CGFloat, leftOffset: CGFloat, rightOffset: CGFloat) {
        guard let player = audioPlayer else { return }
        
        let totalWidth = maxWidth - leftOffset - rightOffset
        
        // Додаємо захист, щоб не ділили на нуль
        guard totalWidth > 0 else { return }

        let adjustedOffset = min(max(offset - leftOffset, 0), totalWidth)

        // Новий час на основі зміщення по всій ширині
        let newTime = (adjustedOffset / totalWidth) * player.duration

        // Оновлюємо поточний час
        player.currentTime = min(max(newTime, 0), player.duration)
    }

    // MARK: - Play from Current Time
    func playFromCurrentTime() {
        guard let player = audioPlayer else { return }
        
        // Start playback from the current time
        if !isPlaying {
            player.play()
            isPlaying = true
            isPaused = false
            startTimer()
        }
    }

    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
            progress = 0.0
            stopTimer()
        }
    }
    
    // MARK: - Static Methods
    static func getAudioDuration(url: URL, completion: @escaping (TimeInterval) -> Void) {
        let asset = AVAsset(url: url)
        
        Task {
            do {
                let duration = try await asset.load(.duration)
                completion(duration.seconds)
            } catch {
                print("Error loading asset duration: \(error.localizedDescription)")
                completion(0.0)
            }
        }
    }
    
    func audioDuration(for url: URL, completion: @escaping (String) -> Void) {
        AudioPlayer.getAudioDuration(url: url) { duration in
            let minutes = Int(duration) / 60
            let seconds = Int(duration) % 60
            completion(String(format: "%02d:%02d", minutes, seconds))
        }
    }
}
