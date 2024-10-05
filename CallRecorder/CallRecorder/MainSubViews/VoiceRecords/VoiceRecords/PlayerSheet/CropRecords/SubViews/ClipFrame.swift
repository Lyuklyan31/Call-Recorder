import SwiftUI

struct ClipFrame: View {
    @State private var leftOffset: CGFloat = 0
    @State private var rightOffset: CGFloat = 0
    let minWidth: CGFloat = 60
    @State private var maxWidth: CGFloat = 0
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
                .scaledToFit()
                .padding(.horizontal, 24)
            
            PlayHeadCrop(leftOffset: $leftOffset, audioURL: audioURL)
                .offset(y: -90)
                .offset(x: getPlayheadOffset())
                .animation(.easeInOut(duration: 0.3), value: audioPlayer.progress)

            HStack {
                makeClipControl(isLeft: true, offset: leftOffset, onChange: ({ newOffset in
                    leftOffset = lastLeftOffset + newOffset
                }), onEnded: { newOffset in
                    lastLeftOffset = lastLeftOffset + newOffset
                })
                Spacer()
                makeClipControl(isLeft: false, offset: rightOffset, onChange: ({ newOffset in
                    rightOffset = newOffset + lastRightOffset
                }), onEnded: { newOffset in
                    lastRightOffset = lastRightOffset + newOffset
                })
            }
            .background {
                GeometryReader(content: { geometry in
                    Rectangle()
                        .fill(Color.clear)
                        .onAppear {
                            maxWidth = geometry.size.width
                        }
                })
            }
            .overlay {
                Rectangle()
                    .fill(Color.clear)
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 4)
                            .frame(width: maxWidth - leftOffset + rightOffset)
                            .offset(x: leftOffset)
                    }
            }
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
                    .onEnded({ gesture in
                        onEnded(gesture.translation.width)
                    })
            )
    }
}



//                                        print("----# getsture translation - \(gesture.translation.width)")
//                                        print("---# last left offset - \(lastLeftOffset)")
//                                        let newLeftOffset = lastLeftOffset + gesture.translation.width * sensitivity
//                                        print("---- new offset - \(newLeftOffset)")
//                                        if newLeftOffset >= sideLimit && (maxWidth - newLeftOffset - rightOffset) >= minWidth {
////                                            withAnimation(.interactiveSpring()) {
//                                                leftOffset = gesture.translation.width
////                                            }
//                                            updateAudioPlayerTime()
//                                        }
//                                    .onEnded { _ in
//                                        lastLeftOffset = leftOffset
//                                        audioPlayer.resetPlayback()
//                                        withAnimation(.easeOut(duration: 0.5)) {
//                                            if (maxWidth - leftOffset - rightOffset) < minWidth {
//                                                leftOffset = maxWidth - rightOffset - minWidth
//                                            }
//                                            updateAudioPlayerTime()
//                                        }
//                                    }



//                Rectangle()
//                    .frame(width: 24, height: 129)
//                    .cornerRadius(12, corners: [.topRight, .bottomRight])
//                    .foregroundColor(.blue)
//                    .overlay {
//                        Image(systemName: "chevron.right")
//                            .foregroundColor(.white)
//                    }
//                    .gesture(
//                        DragGesture()
//                            .onChanged { gesture in
//                                let newRightOffset = lastRightOffset - gesture.translation.width * sensitivity
//                                if newRightOffset >= sideLimit && (maxWidth - leftOffset - newRightOffset) >= minWidth {
//                                    withAnimation(.interactiveSpring()) {
//                                        rightOffset = newRightOffset
//                                    }
//                                    updateAudioPlayerTime()
//                                }
//                            }
//                            .onEnded { _ in
//                                lastRightOffset = rightOffset
//                                audioPlayer.resetPlayback()
//                                withAnimation(.easeOut(duration: 0.5)) {
//                                    if (maxWidth - leftOffset - rightOffset) < minWidth {
//                                        rightOffset = maxWidth - leftOffset - minWidth
//                                    }
//                                    updateAudioPlayerTime()
//                                }
//                            }
//                    )
