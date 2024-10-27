import SwiftUI

struct Progress: View {
    var audioURL: URL
    @EnvironmentObject var audioPlayer: AudioPlayer
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                
                RoundedRectangle(cornerRadius: 28)
                    .foregroundColor(.primaryExtraDark.opacity(0.1))
                    .frame(height: 4)
                    .padding(.horizontal)
                    .padding(.top)
               
                RoundedRectangle(cornerRadius: 28)
                    .foregroundColor(.customPink)
                    .frame(width: CGFloat(audioPlayer.progress) * (geometry.size.width - 32), height: 4)
                    .padding(.horizontal)
                    .padding(.top)
                    .animation(.linear(duration: 0.1), value: audioPlayer.progress)
                
                if audioPlayer.progress != 0.0 {
                    Circle()
                        .foregroundColor(.customPink)
                        .frame(width: 16, height: 16)
                        .offset(x: CGFloat(audioPlayer.progress) * (geometry.size.width - 32) - 8)
                        .padding(.horizontal)
                        .padding(.bottom, -16)
                        .animation(.linear(duration: 0.3), value: audioPlayer.progress)
                }
            }
        }
        .frame(height: 20) 
    }
}

#Preview {
    Progress(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioPlayer())
}
