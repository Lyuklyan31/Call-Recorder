import SwiftUI

struct TimeIntervall: View {
    @State private var audioDuration: String = "00:00"
    @EnvironmentObject var audioPlayer: AudioPlayer
    var audioURL: URL
    
    var body: some View {
        VStack {
            HStack {
                Text(audioDuration)
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
                    .font(.system(size: 12, weight: .medium))
                Spacer()
                
                Text(audioPlayer.curentTime())
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
                    .font(.system(size: 12, weight: .medium))
            }
            .padding(.top, 4)
            .padding(.horizontal)
        }
        .onAppear {
            AudioPlayer.getAudioDuration(url: audioURL) { duration in
                let minutes = Int(duration) / 60
                let seconds = Int(duration) % 60
                audioDuration = String(format: "%02d:%02d", minutes, seconds)
            }
        }
    }
}

#Preview {
    TimeIntervall(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioPlayer())
}
