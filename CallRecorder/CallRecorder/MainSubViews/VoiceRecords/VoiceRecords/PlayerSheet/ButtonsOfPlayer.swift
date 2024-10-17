import SwiftUI

struct ButtonsOfPlayer: View {
    @EnvironmentObject var audioPlayer: AudioPlayer
    var audioURL: URL
    @State private var buttonSpeed: ButtonSpeed = .x1
    @State private var showPlayerSheet = false
    var body: some View {
            HStack {
                Button {
                    switch buttonSpeed {
                    case .x1:
                        buttonSpeed = .x3
                    case .x3:
                        buttonSpeed = .x5
                    case .x5:
                        buttonSpeed = .x10
                    case .x10:
                        buttonSpeed = .x1
                    }
                    audioPlayer.changePlaybackRate(to: buttonSpeed.speedValue)
                    
                } label: {
                    Text(buttonSpeed.title)
                        .foregroundColor(.primary.opacity(0.5))
                        .font(.system(size: 17, weight: .regular))
                        .frame(width: 40)
                }
                .padding()
                
                Spacer()
                
                Button {
                    audioPlayer.seekBack()
                } label: {
                    Image(.backButton10Sec)
                }
                .padding()
                
                Button {
                    if audioPlayer.isPlaying {
                        self.audioPlayer.pausePlayback()
                    } else {
                        self.audioPlayer.startPlayback(audio: self.audioURL)
                    }
                } label: {
                    if audioPlayer.isPlaying {
                        Image(.buttonStopForPlayer)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                    } else {
                        Image(.buttonPlayForPlayer)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                    }
                }
                
                Button {
                    audioPlayer.seekForward()
                } label: {
                    Image(.forvardButton10Sec)
                }
                .padding()
                
                
                Spacer()
                
                Button {
                    showPlayerSheet = true
                    audioPlayer.resetPlayback()
                } label: {
                    Image(.scisor)
                }
                .padding(.trailing)
                .fullScreenCover(isPresented: $showPlayerSheet) {
                    CropRecord(audioURL: audioURL, showSheet: $showPlayerSheet)
                }
            }
            .padding(.top, 8)
            .padding(.horizontal)
        
    }
}

#Preview {
    ButtonsOfPlayer(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioPlayer())
}

enum ButtonSpeed {
    case x1
    case x3
    case x5
    case x10
    
    var title: String {
        switch self {
        case .x1:
            "1x"
        case .x3:
            "3x"
        case .x5:
            "5x"
        case .x10:
            "10x"
        }
    }
    
    var speedValue: Float {
        switch self {
        case .x1:
            return 1.0
        case .x3:
            return 3.0
        case .x5:
            return 5.0
        case .x10:
            return 10.0
        }
    }
}
