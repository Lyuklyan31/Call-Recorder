import SwiftUI
import AVFoundation

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
        
        let startTime = player.currentTime  // Поточний час як початкова точка
        let endTime = player.duration       // Кінцевий час
        
        // Діагностичний вивід для перевірки часу
        print("Cropping audio from \(startTime) to \(endTime)")
        
        let asset = AVAsset(url: audioURL)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            print("Failed to create export session.")
            return
        }
        
        exportSession.outputFileType = .m4a
        let croppedAudioURL = audioURL.deletingLastPathComponent().appendingPathComponent("croppedAudio.m4a")
        
        if FileManager.default.fileExists(atPath: croppedAudioURL.path) {
            try? FileManager.default.removeItem(at: croppedAudioURL)
        }
        
        exportSession.outputURL = croppedAudioURL
        exportSession.timeRange = CMTimeRangeFromTimeToTime(start: CMTime(seconds: startTime, preferredTimescale: 600), end: CMTime(seconds: endTime, preferredTimescale: 600))
        
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                print("Cropped audio saved at \(croppedAudioURL)")
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
