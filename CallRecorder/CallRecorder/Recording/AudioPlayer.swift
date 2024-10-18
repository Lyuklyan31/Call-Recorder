import Foundation
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    @Published var isPlaying = false
    @Published var isPaused = false
    @Published var progress: Double = 0.0
    @Published var audioDurationString: String = "00:00"
    @Published var lastSeccond = 0.0
    
    var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    var duration: TimeInterval {
        audioPlayer?.duration ?? 0
    }
    
    override init() {
        super.init()
    }
    
    // Starts a timer to update the progress and current time display
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.updateProgress()

        }
    }
    
    // Stops the currently running timer
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // Initializes the audio player with a URL and prepares it for playback
    func initializeAudioPlayer(with audio: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.enableRate = true
            
            audioDurationString = formattedDuration(duration)
        } catch {
            print("Failed to initialize audio player with error: \(error.localizedDescription)")
        }
    }
    
    // Starts the playback of the audio from the provided URL
    func startPlayback(audio: URL) {
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.setCategory(.playback, mode: .default, options: [])
            try playbackSession.setActive(true)
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Audio session setup failed with error: \(error.localizedDescription)")
            return
        }
        
        do {
            if audioPlayer == nil {
                audioPlayer = try AVAudioPlayer(contentsOf: audio)
                audioPlayer?.delegate = self
                audioPlayer?.enableRate = true
            }
            audioPlayer?.play()
            
            isPlaying = true
            isPaused = false
            startTimer()
        } catch {
            print("Playback failed with error: \(error.localizedDescription)")
        }
    }
    
    // Resumes playback from the current time if paused, or restarts if not
    func playFromCurrentTime() {
        guard let player = audioPlayer else { return }
        
        if isPaused {
            player.currentTime = lastSeccond
            player.play()
        } else {
            player.play()
        }
        
        isPlaying = true
        isPaused = false
        startTimer()
    }

    // Pauses the playback and stops the timer
    func pausePlayback() {
        guard let player = audioPlayer else { return }
        audioPlayer?.pause()
        lastSeccond = player.currentTime
        isPlaying = false
        isPaused = true
        stopTimer()
    }

    // Stops the playback, resets the progress, and stops the timer
    func stopPlayback() {
        audioPlayer?.stop()
        stopTimer()
        
        // Use DispatchQueue to ensure UI updates are safe
        DispatchQueue.main.async {
            self.isPlaying = false
            self.isPaused = false
            self.progress = 0.0
        }
    }

    // Resets the playback to the start and resets the progress
    func resetPlayback() {
        stopPlayback()
            DispatchQueue.main.async {
            self.audioPlayer?.currentTime = 0
            self.progress = 0
            self.audioPlayer?.currentTime = 0
            self.audioDurationString = self.formattedDuration(self.duration)
        }
    }

    // Seeks forward by a specified number of seconds
    func seekForward(seconds: TimeInterval = 10) {
        guard let player = audioPlayer else { return }
        let newTime = player.currentTime + seconds
        player.currentTime = min(newTime, player.duration)
    }

    // Seeks back by a specified number of seconds
    func seekBack(seconds: TimeInterval = 10) {
        guard let player = audioPlayer else { return }
        let newTime = player.currentTime - seconds
        player.currentTime = max(newTime, 0)
    }

    // Changes the playback rate between 0.5x and 5x
    func changePlaybackRate(to rate: Float) {
        guard let player = audioPlayer else { return }
        
        player.enableRate = true
        
        if rate >= 0.5 && rate <= 5.0 {
            player.rate = rate
            if player.isPlaying {
                print("Playback rate set to \(rate)x")
            } else {
                player.play()
                player.rate = rate
                print("Playback started with rate \(rate)x")
            }
        } else {
            print("Unsupported rate for AVAudioPlayer. Supported rates are between 0.5x and 5x.")
        }
    }

    func lastSeccondd() -> String {
        let currentTime = Int(lastSeccond)
        let minutes = currentTime / 60
        let seconds = currentTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // Returns the current playback time as a formatted string
    func currentTime() -> String {
        guard let player = audioPlayer else {
            return "00:00"
        }
        let currentTime = Int(player.currentTime)
        let minutes = currentTime / 60
        let seconds = currentTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // Returns the remaining playback time as a formatted string
    func remainingTime() -> String {
        guard let player = audioPlayer else { return "00:00" }
        let remaining = player.duration - player.currentTime
        let minutes = Int(remaining) / 60
        let seconds = Int(remaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // Updates the progress based on the current time of the player
    func updateProgress() {
        guard let player = audioPlayer else { return }
        progress = player.currentTime / player.duration
    }

    // Helper function to format the audio duration as a string
    private func formattedDuration(_ duration: TimeInterval) -> String {
        let totalSeconds = Int(duration)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // Retrieves the duration of the audio file asynchronously
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
}
