import SwiftUI

struct MiniPlayerView: View {
    
    // MARK: - Properties
    @State private var showPlayerSheet = false
    @State private var detent: PresentationDetent = .large
    private var detents: Set<PresentationDetent> {
        [.medium, .large]
    }

    @EnvironmentObject var audioPlayer: AudioPlayer
    @Environment(\.dismiss) var dismiss
    var audioURL: URL
    
    // MARK: - Body
    var body: some View {
        let creationDate = getFileDate(for: audioURL)
        let formattedDate = creationDate?.formattedDate() ?? "Unknown date"
        
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.backraundWhite, .backraundPink]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            if audioPlayer.isPlaying || audioPlayer.isPaused {
                VStack {
                    ZStack(alignment: .leading) {
                        Capsule()
                            .foregroundColor(.primaryExtraDark.opacity(0.1))
                            .frame(height: 4)
                            .padding(.top, 3.36)
                            .padding(.horizontal, 1)
                        
                        Capsule()
                            .foregroundColor(.customPink)
                            .frame(width: CGFloat(audioPlayer.progress * UIScreen.main.bounds.width), height: 4)
                            .padding(.top, 3.36)
                            .padding(.horizontal, 1)
                            .animation(.linear(duration: 0.1), value: audioPlayer.progress)
                    }
                    Spacer()
                }
            }
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
        }
        .modifier(
            PairingSheet(
                isShowing: $showPlayerSheet,
                isExpandedByDefault: false,
                defaultDetent: .medium,
                title: "Pairing Sheet",
                closeAction: {
                    
                },
                sheetContent: {
                    PlayerSheet(showSheet: $showPlayerSheet, audioURL: audioURL)
                }
            )
        )
        
        .onChange(of: showPlayerSheet) { newValue in
            if newValue == false {
                dismiss()
            }
        }
        .onDisappear {
            self.audioPlayer.resetPlayback()
        }
    }
}

#Preview {
    MiniPlayerView(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioRecorder())
        .environmentObject(AudioPlayer())
}
