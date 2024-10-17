import SwiftUI

struct TimePlayerInterval: View {
    @State private var audioDuration: String = "00:00"
    @EnvironmentObject var audioPlayer: AudioPlayer
    var audioURL: URL
    
    var body: some View {
        VStack {
            HStack {
                Text(formatTime(audioPlayer.progress * audioPlayer.duration))
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
                    .font(.system(size: 12, weight: .medium))
                
                Spacer()
                
                Text(audioDuration)
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
                    .font(.system(size: 12, weight: .medium))
                
            }
            .padding(.top, 4)
            .padding(.horizontal)
        }
        .onAppear {
            audioPlayer.initializeAudioPlayer(with: audioURL)
        
            AudioPlayer.getAudioDuration(url: audioURL) { duration in
                let minutes = Int(duration) / 60
                let seconds = Int(duration) % 60
                audioDuration = String(format: "%02d:%02d", minutes, seconds)
            }
            
            // Start a timer to update current time every 0.1 seconds
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                if let player = audioPlayer.audioPlayer, player.isPlaying {
                    audioPlayer.progress = player.currentTime / player.duration
                }
            }
        }
    }
    
    private func formatTime(_ time: Double) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    TimePlayerInterval(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioPlayer())
}
