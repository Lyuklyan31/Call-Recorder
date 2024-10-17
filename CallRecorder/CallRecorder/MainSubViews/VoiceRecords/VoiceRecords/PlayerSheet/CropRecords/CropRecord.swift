import SwiftUI
import AVFoundation

struct CropRecord: View {
    @EnvironmentObject var audioPlayer: AudioPlayer
    @EnvironmentObject var audioRecorder: AudioRecorder
    var audioURL: URL
    let maxWidth = UIScreen.main.bounds.width - 8
    @Binding var showSheet: Bool
    
    // Array to store cropped recordings
    @State private var croppedRecordings: [URL] = []
    @State private var cropCount = 0  // Counter for numbering crops
    
    var body: some View {
        let creationDate = getFileDate(for: audioURL)
        let formattedDate = creationDate?.formattedDate() ?? "Unknown date"
        
        ZStack {
            MakeBackgroundView()
            VStack {
                NavigationBarSubView(title: "Crop Record")
                    .padding(.bottom, 54)
                
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
                        audioPlayer.pausePlayback()
                    } else {
                        audioPlayer.playFromCurrentTime()
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
                
                Spacer()
                HStack {
                    Spacer()
                    
                    Button {
                        audioPlayer.resetPlayback()
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
                        cropAudio()
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
                
                // Display list of cropped recordings
                List {
                    ForEach(croppedRecordings, id: \.self) { recording in
                        Text(recording.lastPathComponent)
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
        .onAppear {
            audioPlayer.initializeAudioPlayer(with: audioURL)
        }
    }
    
    private func cropAudio() {
        guard let player = audioPlayer.audioPlayer else {
            print("Audio player is nil.")
            return
        }
        
        let startTime = player.currentTime
        let endTime = startTime + 2.0 // Keep the last 2 seconds
        
        // Діагностичний вивід для перевірки часу
        print("Cropping audio from \(startTime) to \(endTime)")
        
        let asset = AVAsset(url: audioURL)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            print("Failed to create export session.")
            return
        }
        
        exportSession.outputFileType = .m4a
        let croppedAudioURL = audioURL.deletingLastPathComponent().appendingPathComponent("croppedAudio_\(UUID().uuidString).m4a")
        
        if FileManager.default.fileExists(atPath: croppedAudioURL.path) {
            try? FileManager.default.removeItem(at: croppedAudioURL)
        }
        
        exportSession.outputURL = croppedAudioURL
        exportSession.timeRange = CMTimeRangeFromTimeToTime(
            start: CMTime(seconds: startTime, preferredTimescale: 600),
            end: CMTime(seconds: endTime, preferredTimescale: 600)
        )
        
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                print("Cropped audio saved at \(croppedAudioURL)")
                
                // Create new recording data model with the current date
                let newRecording = RecordingDataModel(fileURL: croppedAudioURL, createdAt: Date())
                
                // Add the new recording to your audio recorder or update your recordings list
                DispatchQueue.main.async {
                    self.audioRecorder.recordings.append(newRecording) // Update your list
                }
                
            case .failed:
                if let error = exportSession.error {
                    print("Failed to crop audio with error: \(error.localizedDescription)")
                }
            case .cancelled:
                print("Export session was cancelled.")
            default:
                print("Unknown export status: \(exportSession.status.rawValue)")
            }
        }
    }
}
