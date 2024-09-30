import SwiftUI

struct CropRecord: View {
    @EnvironmentObject var audioPlayer: AudioPlayer
    var audioURL: URL
    let maxWidth = UIScreen.main.bounds.width - 8
    @Binding var showSheet: Bool
    
    var body: some View {
        let creationDate = getFileDate(for: audioURL)
        let formattedDate = creationDate?.formattedDate() ?? "Unknown date"
        ZStack {
            MakeBackgroundView()
            VStack {
                NavigationBarSubView(title: "Crop Record")
                    .padding(.bottom,54)
                
                Text(audioURL.deletingPathExtension().lastPathComponent)
                    .font(.system(size: 24, weight: .semibold))
                    .padding(.bottom, 16)
                
                Text(formattedDate)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
                    .padding(.bottom, 100)
                
                ClipFrame(audioURL: audioURL)
                
                TimePlayerInterval(audioURL: audioURL)
                
                Button {
                    if audioPlayer.isPlaying {
                        audioPlayer.playFromCurrentTime()
                    } else {
                        self.audioPlayer.startPlayback(audio: self.audioURL)
                    }
                } label: {
                    Image(.buttonPlayForPlayer)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                }
                
                Spacer()
                HStack {
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        VStack {
                            Image(.resetButton)
                            Text("Reset")
                                .foregroundColor(.primaryExtraDark.opacity(0.5))
                        }
                    }
                    
                    Spacer()
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        VStack {
                            Image(.cutButton)
                            Text("Crop")
                                .foregroundColor(.primaryExtraDark.opacity(0.5))
                        }
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 66)
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    CropRecord(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!, showSheet: .constant(false))
        .environmentObject(AudioPlayer())
}
