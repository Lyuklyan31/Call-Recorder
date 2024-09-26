import SwiftUI

struct ClipFrame: View {
    @State private var leftOffset: CGFloat = 8
    @State private var rightOffset: CGFloat = 8
    let minWidth: CGFloat = 60
    let maxWidth = UIScreen.main.bounds.width - 16
    let sideLimit: CGFloat = 8
    @State private var lastLeftOffset: CGFloat = 0
    @State private var lastRightOffset: CGFloat = 0
    let sensitivity: CGFloat = 1.5
    
    var audioURL: URL
    @EnvironmentObject var audioPlayer: AudioPlayer

    var body: some View {
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
                                        withAnimation(.easeOut(duration: 0.1)) {
                                            leftOffset = newLeftOffset
                                        }
                                    }
                                }
                                .onEnded { gesture in
                                    lastLeftOffset = leftOffset
                                    withAnimation(.spring()) {
                                        if (maxWidth - leftOffset - rightOffset) < minWidth {
                                            leftOffset = maxWidth - rightOffset - minWidth
                                        }
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
                                        withAnimation(.easeOut(duration: 0.1)) {
                                            rightOffset = newRightOffset
                                        }
                                    }
                                }
                                .onEnded { gesture in
                                    lastRightOffset = rightOffset
                                    audioPlayer.resetPlayback()
                                    withAnimation(.spring()) {
                                        if (maxWidth - leftOffset - rightOffset) < minWidth {
                                            rightOffset = maxWidth - leftOffset - minWidth
                                        }
                                    }
                                }
                        )
                }
            )
            .offset(x: (leftOffset - rightOffset) / 2)
        
        PlayHeadCrop(leftOffset: $leftOffset, audioURL: audioURL)
            .offset(y: -90)
            .offset(x: CGFloat(audioPlayer.progress * (UIScreen.main.bounds.width - 32)) - 8)
            .animation(.linear(duration: 0.1), value: audioPlayer.progress)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    ClipFrame(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioPlayer())
}
