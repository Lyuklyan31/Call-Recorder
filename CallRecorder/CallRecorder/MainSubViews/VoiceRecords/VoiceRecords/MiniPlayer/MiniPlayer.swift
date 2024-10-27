import SwiftUI

struct MiniPlayerView: View {
    
    // MARK: - Properties
    @EnvironmentObject var audioPlayer: AudioPlayer
    @Environment(\.dismiss) var dismiss
    @Binding var audioURL: URL!
    @Binding var showPlayerSheet: Bool
    
    // MARK: - Body
    var body: some View {
        let creationDate = getFileDate(for: audioURL)
        let formattedDate = creationDate?.formattedDate() ?? "Unknown date"
        VStack {
            ZStack {
                MakeBackgroundView()
                Button {
                    showPlayerSheet.toggle()
                } label: {
                    VStack {
                        HStack {
                            Image(.microphoneForPlayer)
                            
                            VStack(alignment: .leading) {
                                Text(audioURL.deletingPathExtension().lastPathComponent)
                                    .foregroundColor(.primary)
                                    .font(.system(size: 19, weight: .medium))
                                    .padding(.bottom, 2)
                                Text("\(formattedDate)")
                                    .foregroundColor(.primaryExtraDark.opacity(0.5))
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 16) {
                                if audioPlayer.isPlaying == false {
                                    Button(action: {
                                        self.audioPlayer.startPlayback(audio: self.audioURL)
                                    }) {
                                        Image(.buttonPlayForPlayer)
                                    }
                                } else {
                                    Button(action: {
                                        self.audioPlayer.pausePlayback()
                                    }) {
                                        Image(.buttonStopForPlayer)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 36, height: 36)
                                    }
                                }
                                
                                Button {
                                    if self.audioPlayer.isPlaying {
                                        self.audioPlayer.seekForward()
                                    }
                                } label: {
                                    Image(.forvardButton10Sec)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .overlay {
                    if audioPlayer.isPlaying || audioPlayer.isPaused {
                        VStack {
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .foregroundColor(.primaryExtraDark.opacity(0.1))
                                    .frame(height: 5)
                                    .padding(.top, 1)
                                    .padding(.horizontal, 1)
                                
                                Capsule()
                                    .foregroundColor(.customPink)
                                    .frame(width: CGFloat(audioPlayer.progress * UIScreen.main.bounds.width), height: 5)
                                    .padding(.top, 1)
                                    .padding(.horizontal, 1)
                                    .animation(.linear(duration: 0.1), value: audioPlayer.progress)
                            }
                            Spacer()
                        }
                    }
                }
            }
           
        }
        .frame(height: UIScreen.main.bounds.height * 0.09)
    }
}
