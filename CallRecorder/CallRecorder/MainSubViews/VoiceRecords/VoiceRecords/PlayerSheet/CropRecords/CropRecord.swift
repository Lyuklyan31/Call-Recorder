import SwiftUI
import AVFoundation

struct CropRecord: View {
    // MARK: - Environment Objects
    @EnvironmentObject var audioPlayer: AudioPlayer
    @EnvironmentObject var audioRecorder: AudioRecorder
    @State private var resetTrigger: Bool = false
    
    // MARK: - Properties
    var audioURL: URL
    @State private var cropCounter = 1
    let maxWidth = UIScreen.main.bounds.width - 8
    @Binding var showSheet: Bool
    
    // MARK: - State Variables
    @State private var croppedRecordings: [URL] = []
    @State private var cropCount = 0  // Counter for numbering crops
    
    // MARK: - Body
    var body: some View {
        let creationDate = getFileDate(for: audioURL)
        let formattedDate = creationDate?.formattedDate() ?? "Unknown date"
        
        ZStack {
            MakeBackgroundView()
            VStack {
                // MARK: - Navigation Bar
                NavigationBarSubView(title: "Crop Record")
                    .padding(.bottom, 54)
                
                // MARK: - Audio File Name and Date
                Text(audioURL.deletingPathExtension().lastPathComponent)
                    .font(.system(size: 24, weight: .semibold))
                    .padding(.bottom, 16)
                
                Text(formattedDate)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
                    .padding(.bottom, 100)
                
                // MARK: - Audio Clip Frame and Player
                ClipFrame(resetTrigger: $resetTrigger, audioURL: audioURL)
                TimePlayerInterval(audioURL: audioURL)
                
                // MARK: - Play/Pause Button
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
                
                // MARK: - Control Buttons (Reset, Crop)
                HStack {
                    Spacer()
                    
                    Button {
                        resetTrigger.toggle()
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
                
                // MARK: - Cropped Recordings List
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
    
    // MARK: - Crop Audio Function
    private func cropAudio() {
        guard let player = audioPlayer.audioPlayer else {
            print("Audio player is nil.")
            return
        }
        
        let startTime = player.currentTime
        let endTime = timeStringToDouble(audioPlayer.audioDurationString)
        
        print("Cropping audio from \(startTime) to \(endTime)")
        
        let asset = AVAsset(url: audioURL)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            print("Failed to create export session.")
            return
        }
        
        exportSession.outputFileType = .m4a
        
        // Generate a unique identifier for the filename using current timestamp and counter
        let uniqueID = Int(Date().timeIntervalSince1970)
        let croppedAudioURL = audioURL
            .deletingLastPathComponent()
            .appendingPathComponent("croppedAudio_\(uniqueID)_\(cropCounter).m4a")
        
        // Remove existing file
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
                
                let newRecording = RecordingDataModel(fileURL: croppedAudioURL, createdAt: Date())
                
                DispatchQueue.main.async {
                    self.audioRecorder.recordings.append(newRecording)
                    self.cropCounter += 1
                    self.croppedRecordings.append(croppedAudioURL)
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
    
    // MARK: - Helper: Time String to Double
    private func timeStringToDouble(_ timeString: String) -> Double {
        let components = timeString.split(separator: ":")
        guard components.count == 2,
              let minutes = Double(components[0]),
              let seconds = Double(components[1]) else {
            return 0.0
        }
        return (minutes * 60) + seconds
    }
}
