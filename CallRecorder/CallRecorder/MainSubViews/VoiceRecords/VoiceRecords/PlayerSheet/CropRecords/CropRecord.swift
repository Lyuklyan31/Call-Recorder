import SwiftUI

struct CropRecord: View {
    @EnvironmentObject var audioPlayer: AudioPlayer
    var audioURL: URL
    
    var body: some View {
        VStack {
            NavigationBarSubView(title: "Crop Record")
                
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    CropRecord(audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioPlayer())
}
