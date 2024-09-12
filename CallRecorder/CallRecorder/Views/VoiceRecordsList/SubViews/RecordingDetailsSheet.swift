import SwiftUI
import Combine

struct RecordingDetailsSheet: View {
    
    // MARK: - Properties
    @State private var showSheet = false
    @ObservedObject var audioPlayer = AudioPlayer()
    var audioURL: URL
    
    // MARK: - Body
    var body: some View {
        let creationDate = getFileDate(for: audioURL)
        let formattedDate = creationDate?.formattedDate() ?? "Unknown date"
        
        ZStack {
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
            Button {
                showSheet.toggle()
            } label: {
                VStack {
                    HStack {
                        Image(.microphoneForPlayer)
                        
                        VStack(alignment: .leading) {
                            Text("Memo")
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
                                    Image(.play)
                                        .imageScale(.large)
                                }
                            } else {
                                Button(action: {
                                    self.audioPlayer.stopPlayback()
                                }) {
                                    Image(.stop)
                                        .imageScale(.large)
                                }
                            }
                            
                            Button {
                                if self.audioPlayer.isPlaying {
                                    self.audioPlayer.seekForward()
                                }
                            } label: {
                                Image(.button10Sec)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            PlayerSheet(audioURL: audioURL)
                .presentationDetents([.fraction(0.6)])
        }
        .onDisappear {
            self.audioPlayer.resetPlayback()
        }
    }
  
    // MARK: - Helpers
    func getCreationDate(from url: URL) -> String? {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
            
            if let creationDate = attributes[.creationDate] as? Date {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                return formatter.string(from: creationDate)
            }
        } catch {
            print("Error retrieving file attributes: \(error)")
        }
        return nil
    }
}
