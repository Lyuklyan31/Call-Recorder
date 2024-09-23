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
               
               
                    Image(.voiceLine)
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .overlay {
                            ClipFrame()
                        }
                TimePlayerInterval(audioURL: audioURL)
                        
                Spacer()
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    CropRecord(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!, showSheet: .constant(false))
        .environmentObject(AudioPlayer())
}
