import SwiftUI

struct ClipFrame: View {
    @State private var leftOffset: CGFloat = 20
    @State private var rightOffset: CGFloat = 20
    let minWidth: CGFloat = 60
    let maxWidth = UIScreen.main.bounds.width
    let sideLimit: CGFloat = 20
    @State private var lastLeftOffset: CGFloat = 0
    @State private var lastRightOffset: CGFloat = 0
    let sensitivity: CGFloat = 1.5
    
    var audioURL: URL
    @EnvironmentObject var audioPlayer: AudioPlayer
    
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            Image(.voiceLine)
                .resizable()
                .padding(.horizontal, 35)
                .frame(height: 129)
                .scaledToFit()
            
            PlayHeadCrop(leftOffset: $leftOffset, audioURL: audioURL)
                .offset(y: -90)
                .offset(x: getPlayheadOffset())
                .animation(.easeInOut(duration: 0.3), value: audioPlayer.progress)

            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue, lineWidth: 4)
                .frame(width: maxWidth - leftOffset - rightOffset, height: 129)
                .overlay(
                    HStack {
                        Rectangle()
                            .frame(width: 24, height: 129)
                            .cornerRadius(12, corners: [.topLeft, .bottomLeft])
                            .foregroundColor(.blue)
                            .overlay {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                            }
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        let newLeftOffset = lastLeftOffset + gesture.translation.width * sensitivity
                                        if newLeftOffset >= sideLimit && (maxWidth - newLeftOffset - rightOffset) >= minWidth {
                                            withAnimation(.interactiveSpring()) {
                                                leftOffset = newLeftOffset
                                            }
                                            updateAudioPlayerTime()
                                        }
                                    }
                                    .onEnded { _ in
                                        lastLeftOffset = leftOffset
                                        audioPlayer.resetPlayback()
                                        withAnimation(.easeOut(duration: 0.5)) {
                                            if (maxWidth - leftOffset - rightOffset) < minWidth {
                                                leftOffset = maxWidth - rightOffset - minWidth
                                            }
                                            updateAudioPlayerTime()
                                        }
                                    }
                            )
                        
                        Spacer()
                        
                        Rectangle()
                            .frame(width: 24, height: 129)
                            .cornerRadius(12, corners: [.topRight, .bottomRight])
                            .foregroundColor(.blue)
                            .overlay {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        let newRightOffset = lastRightOffset - gesture.translation.width * sensitivity
                                        if newRightOffset >= sideLimit && (maxWidth - leftOffset - newRightOffset) >= minWidth {
                                            withAnimation(.interactiveSpring()) {
                                                rightOffset = newRightOffset
                                            }
                                            updateAudioPlayerTime()
                                        }
                                    }
                                    .onEnded { _ in
                                        lastRightOffset = rightOffset
                                        audioPlayer.resetPlayback()
                                        withAnimation(.easeOut(duration: 0.5)) {
                                            if (maxWidth - leftOffset - rightOffset) < minWidth {
                                                rightOffset = maxWidth - leftOffset - minWidth
                                            }
                                            updateAudioPlayerTime()
                                        }
                                    }
                            )
                    }
                )
                .offset(x: (leftOffset - rightOffset) / 2)
        }
        .onAppear {
            audioPlayer.initializeAudioPlayer(with: audioURL)
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                if let player = audioPlayer.audioPlayer, player.isPlaying {
                    audioPlayer.progress = player.currentTime / player.duration
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func getPlayheadOffset() -> CGFloat {
        let availableWidth = maxWidth - 64
        let playheadPosition = CGFloat(audioPlayer.progress) * availableWidth
        
        return min(max(playheadPosition, 0), availableWidth)
    }

    private func updateAudioPlayerTime() {
        let audioDuration = audioPlayer.duration
        let totalWidth = maxWidth - 64
        
      
        let secondsWidth = audioDuration > 0 ? totalWidth / audioDuration : 0
        
        let newTime = leftOffset / secondsWidth
        
        audioPlayer.audioPlayer?.currentTime = min(max(newTime, 0), audioDuration)
    }
}

#Preview {
    ClipFrame(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioPlayer())
}
