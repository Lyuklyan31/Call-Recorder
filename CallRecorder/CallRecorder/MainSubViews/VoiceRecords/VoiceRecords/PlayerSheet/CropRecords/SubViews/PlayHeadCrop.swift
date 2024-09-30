import SwiftUI

struct PlayHeadCrop: View {
    @Binding var leftOffset: CGFloat
    @State private var audioDuration: String = "00:00"
    @EnvironmentObject var audioPlayer: AudioPlayer
    var audioURL: URL
    
    var body: some View {
        HStack {
            HStack {
                HStack(spacing: 3) {
                    Text(audioPlayer.currentTime())
                        .foregroundColor(.white)
                        .font(.system(size: 12, weight: .medium))
                    
                    Text(audioDuration)
                        .foregroundColor(.white.opacity(0.5))
                        .font(.system(size: 12, weight: .medium))
                }
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .foregroundColor(.blue)
                        .frame(width: calculateCapsuleWidth() + 16)
                )
            }
            .overlay {
                Triangle()
                    .fill(Color.blue)
                    .frame(width: 16, height: 8)
                    .rotationEffect(.degrees(180))
                    .offset(y: 14.4)
                    .overlay {
                        Rectangle()
                            .frame(width: 2, height: 143)
                            .foregroundColor(.blue)
                            .offset(y: 84)
                    }
            }
            .offset(x: leftOffset - 12)
            Spacer()
                
        }
        .onAppear {
            audioPlayer.initializeAudioPlayer(with: audioURL)
            
            AudioPlayer.getAudioDuration(url: audioURL) { duration in
                let minutes = Int(duration) / 60
                let seconds = Int(duration) % 60
                audioDuration = String(format: "%02d:%02d", minutes, seconds)
            }
        }
    }
    private func calculateCapsuleWidth() -> CGFloat {
            let text1Width = (audioPlayer.currentTime() as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 12, weight: .medium)]).width
            let text2Width = (audioDuration as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 12, weight: .medium)]).width
            return text1Width + text2Width
        }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        path.move(to: CGPoint(x: 0, y: height))
        path.addQuadCurve(to: CGPoint(x: width / 2, y: 0), control: CGPoint(x: width * 0.5, y: height * 0.9))
        path.addQuadCurve(to: CGPoint(x: width, y: height), control: CGPoint(x: width * 0.5, y: height * 0.9))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    PlayHeadCrop(leftOffset: .constant(8), audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioPlayer())
}
