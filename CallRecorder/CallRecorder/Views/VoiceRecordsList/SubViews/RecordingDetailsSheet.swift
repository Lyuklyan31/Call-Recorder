//
//  RecordingDetailsSheet.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 08.09.2024.
//

import SwiftUI

struct RecordingDetailsSheet: View {
    
    // MARK: - Properties
    @State private var showSheet = false
    @ObservedObject var audioPlayer = AudioPlayer()
    var audioURL: URL
    
    // MARK: - Body
    var body: some View {
        Button {
            showSheet.toggle()
        } label: {
            ZStack {
                HStack {
                    Image(.microphoneForPlayer)
                    
                    VStack(alignment: .leading) {
                        Text("Memo")
                            .foregroundColor(.primary)
                        
                        Text("\(audioURL.lastPathComponent)")
                            .padding(.bottom, 8)
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
                            
                        } label: {
                            Image(.button10Sec)
                        }
                    }
                }
                .padding()
            }
            .sheet(isPresented: $showSheet) {
                PlayerSheet(audioURL: audioURL)
                    .presentationDetents([.fraction(0.6)])
            }
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

