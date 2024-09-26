//  PlayHeadCrop.swift
//  CallRecorder
//
//  Created by Mac on 27.09.2024.
//

import SwiftUI

struct PlayHeadCrop: View {
    @Binding var leftOffset: CGFloat
    @State private var audioDuration: String = "00:00"
    @EnvironmentObject var audioPlayer: AudioPlayer
    var audioURL: URL
    
    var body: some View {
        HStack {
            HStack {
                HStack {
                    Text(audioPlayer.currentTime())
                        .foregroundColor(.white)
                        .font(.system(size: 12, weight: .medium))
                        .padding(.leading, 2)
                    
                    Text(audioDuration)
                        .foregroundColor(.white.opacity(0.5))
                        .font(.system(size: 12, weight: .medium))
                        .padding(.trailing, 2)
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .foregroundColor(.blue)
                )
            }
            .overlay {
                Path { path in
                    let width: CGFloat = 16
                    let height: CGFloat = 8
                    
                    path.move(to: CGPoint(x: 0, y: height))
                    path.addQuadCurve(to: CGPoint(x: width / 2, y: 0), control: CGPoint(x: width * 0.5, y: height * 0.9))
                    path.addQuadCurve(to: CGPoint(x: width, y: height), control: CGPoint(x: width * 0.5, y: height * 0.9))
                    path.closeSubpath()
                }
                .fill(Color.blue)
                .frame(width: 16, height: 8)
                .rotationEffect(.degrees(180))
                .offset(y: 14.4)
                .overlay {
                    Rectangle()
                        .frame(width: 2, height: 143)
                        .foregroundColor(.blue)
                        .offset(y: 84)
                }
            }
            .offset(x: -12)
            .offset(x: leftOffset)
            Spacer()
        }
    }
}

#Preview {
    PlayHeadCrop(leftOffset: .constant(8), audioURL: URL(string: "https://www.example.com/audiofile.m4a")!)
        .environmentObject(AudioPlayer())
}
