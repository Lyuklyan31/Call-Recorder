import SwiftUI

// MARK: - RecordingRow
struct RecordingRow: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var audioPlayer: AudioPlayer
    var audioURL: URL
    
    @Binding var selectedRecording: URL?
    @Binding var showSheet: Bool
    
    @State private var audioDuration: String = "00:00"
    
    // MARK: - Body
    var body: some View {
        let creationDate = getFileDate(for: audioURL)
        let formattedDate = creationDate?.formattedDate() ?? "Unknown date"
       
        let isFavorite = audioRecorder.recordings.first(where: { $0.fileURL == audioURL })?.isFavorite ?? false
        
        Button {
            selectedRecording = audioURL
        } label: {
            HStack {
                Image(.microphoneRec)
                    .padding(.trailing, 8)
                VStack(alignment: .leading) {
                    HStack {
                        Text(audioURL.deletingPathExtension().lastPathComponent)
                            .foregroundColor(.primary)
                            .font(.system(size: 17, weight: .regular))
                    }
                    
                    Text(formattedDate)
                        .padding(.bottom, 2)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.primaryExtraDark.opacity(0.5))
                    
                    let tags = audioRecorder.tagsForRecording(url: audioURL)
                    VStack {
                        if !tags.isEmpty {
                            HStack(spacing: 8) {
                                ForEach(tags, id: \.self) { tag in
                                    Text(tag)
                                        .padding(.horizontal)
                                        .padding(.vertical, 4)
                                        .background(Capsule().foregroundColor(.customPink.opacity(0.1)))
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                if isFavorite {
                    Image(.favoriteFill)
                        .foregroundColor(.yellow)
                }
                
                Text(audioDuration)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
            }
        }
        .onChange(of: selectedRecording) { newValue in
            if newValue == audioURL {
                showSheet = true
            }
        }
        .onAppear {
            AudioPlayer.getAudioDuration(url: audioURL) { duration in
                let minutes = Int(duration) / 60
                let seconds = Int(duration) % 60
                audioDuration = String(format: "%02d:%02d", minutes, seconds)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    RecordingsList(selection: .constant(0), showMiniPlayer: .constant(false))
        .environmentObject(AudioRecorder())
        .environmentObject(AudioPlayer())
}
