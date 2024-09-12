import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    @Published var isPlaying = false
    @Published var isPause = false
    @Published var progress: Double = 0.0
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    override init() {
        super.init()
        startTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.updateProgress()
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
        } catch let error {
            print("Playback failed with error: \(error.localizedDescription)")
        }
    }
    
    func stopPlayback() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    func resetPlayback() {
        stopPlayback()
        progress = 0.0
    }
    
    func seekForward(seconds: TimeInterval = 10) {
        guard let player = audioPlayer else { return }
        let newTime = player.currentTime + seconds
        player.currentTime = min(newTime, player.duration)
    }
    
    private func updateProgress() {
        guard let player = audioPlayer, player.isPlaying else {
            return
        }
        progress = player.currentTime / player.duration
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
            progress = 0.0
        }
    }
    
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
