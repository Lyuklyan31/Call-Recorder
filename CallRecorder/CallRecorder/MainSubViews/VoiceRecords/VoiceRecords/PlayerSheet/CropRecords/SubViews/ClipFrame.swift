import SwiftUI

struct ClipFrame: View {
    @State private var leftOffset: CGFloat = 16
    @State private var rightOffset: CGFloat = -16
    @State private var maxWidth: CGFloat = 0
    @State private var lastLeftOffset: CGFloat = 16
    @State private var lastRightOffset: CGFloat = -16
    @State private var timer: Timer?
    @State private var lastPlaybackTime: Double = 0
    
    @EnvironmentObject var audioPlayer: AudioPlayer
    
    let minimumSpacing: CGFloat = 50
    var audioURL: URL

    var body: some View {
        ZStack {
            Image(.voiceLine)
                .resizable()
                .frame(height: 129)
                .padding(.horizontal, 32)
            
            PlayHeadCrop(leftOffset: $leftOffset, audioURL: audioURL)
                .offset(y: -87)
                .offset(x: getPlayheadOffset() - 16)
                .animation(.easeInOut(duration: 0.3), value: audioPlayer.progress)
                
            HStack {
                makeClipControl(isLeft: true, offset: leftOffset, onChange: ({ newOffset in
                    leftOffset = max(lastLeftOffset + newOffset, 16)
                    leftOffset = min(leftOffset, maxWidth - (-rightOffset) - minimumSpacing)
                    updateAudioPlayerTime()
                    audioPlayer.progress = 0.0
                    if audioPlayer.isPlaying {
                        audioPlayer.resetPlayback()
                    }
                }), onEnded: { newOffset in
                    lastLeftOffset = leftOffset
                    audioPlayer.progress = 0.0
                    if audioPlayer.isPlaying {
                        audioPlayer.resetPlayback()
                    }
                    updateAudioPlayerTime()
                })

                Spacer()

                makeClipControl(isLeft: false, offset: rightOffset, onChange: ({ newOffset in
                    rightOffset = min(lastRightOffset + newOffset, -16)
                    rightOffset = max(rightOffset, -(maxWidth - leftOffset - minimumSpacing))
                    audioPlayer.progress = 0.0
                    if audioPlayer.isPlaying {
                        audioPlayer.resetPlayback()
                    }
                    updateAudioDuration()
                    updateAudioPlayerTime()
                }), onEnded: { newOffset in
                    lastRightOffset = rightOffset
                    audioPlayer.progress = 0.0
                    if audioPlayer.isPlaying {
                        audioPlayer.resetPlayback()
                    }
                    updateAudioDuration()
                    updateAudioPlayerTime()
                })
            }
            .background {
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.clear)
                        .onAppear {
                            maxWidth = geometry.size.width
                        }
                }
            }
            .overlay {
                Rectangle()
                    .fill(Color.clear)
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        let adjustedWidth = max(0, maxWidth - leftOffset + rightOffset)
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 4)
                            .frame(width: adjustedWidth)
                            .offset(x: leftOffset)
                    }
            }

            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 16)
        }
        .onAppear {
            audioPlayer.initializeAudioPlayer(with: audioURL)
            audioPlayer.audioPlayer?.currentTime = lastPlaybackTime
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                if let player = audioPlayer.audioPlayer {
                    if player.isPlaying {
                        audioPlayer.progress = player.currentTime / player.duration
                    } else {
                        lastPlaybackTime = player.currentTime
                    }
                }
            }
        }
        .onChange(of: audioPlayer.isPlaying) { newValue in
            if !newValue {
                shiftClipControls()
            }
        }
    }

    private func shiftClipControls() {
        leftOffset += 0.1
        rightOffset -= 0.1
        updateAudioDuration()
        updateAudioPlayerTime()
    }

    private func getPlayheadOffset() -> CGFloat {
        let mainWorkingWidth = maxWidth - 44
        
        if audioPlayer.isPlaying {
            let newOffset = min(mainWorkingWidth + rightOffset, max(mainWorkingWidth * audioPlayer.progress, leftOffset))
            stopAudioIfNeeded(newOffset: newOffset, workingOffset: mainWorkingWidth)
            return newOffset
        } else {
            return max(mainWorkingWidth * audioPlayer.progress, leftOffset)
        }
    }

    private func stopAudioIfNeeded(newOffset: Double, workingOffset: Double) {
        if newOffset >= workingOffset + rightOffset && workingOffset > 0 {
            audioPlayer.resetPlayback()
        }
    }

    private func updateAudioPlayerTime() {
        let audioDuration = audioPlayer.duration
        let totalWidth = maxWidth - 32
        let secondsPerPixel = audioDuration / totalWidth
        let newTime = (leftOffset - 16) * secondsPerPixel
        audioPlayer.audioPlayer?.currentTime = min(max(newTime, 0), audioDuration)
    }
    
    private func updateAudioDuration() {
        let audioDuration = audioPlayer.duration
        let totalWidth = maxWidth - 48
        let secondsPerPixel = audioDuration > 0 ? totalWidth / audioDuration : 0
        let elapsedTimeFromRightShift = (rightOffset + 16) / secondsPerPixel

        let remainingTime = max(audioDuration + elapsedTimeFromRightShift, 0)

        audioPlayer.audioDurationString = String(format: "%02d:%02d", Int(remainingTime) / 60, Int(remainingTime) % 60)
    }
}

// MARK: - Subviews

private extension ClipFrame {
    func makeClipControl(
        isLeft: Bool,
        offset: CGFloat,
        onChange: @escaping (CGFloat) -> Void,
        onEnded: @escaping (CGFloat) -> Void
    ) -> some View {
        Rectangle()
            .foregroundStyle(Color.clear)
            .frame(width: 24, height: 129)
            .overlay {
                Rectangle()
                    .cornerRadius(12, corners: isLeft ? [.topLeft, .bottomLeft] : [.topRight, .bottomRight])
                    .foregroundColor(.blue)
                    .overlay {
                        Image(systemName: "chevron.\(isLeft ? "left" : "right")")
                            .foregroundColor(.white)
                    }
                    .offset(x: offset)
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        onChange(gesture.translation.width)
                    }
                    .onEnded { gesture in
                        onEnded(gesture.translation.width)
                    }
            )
    }
}
