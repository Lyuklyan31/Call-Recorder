//
//  ChoosingStore.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 08.09.2024.
//

import SwiftUI

struct ChoosingStorage: View {
    
    @State private var iCloudChoose = false
    @State private var iPhoneChoose = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.backraundWhite, .backraundPink]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            VStack {
                NavigationBarSubView(title: "Records Storage")
                    .padding(.bottom, 24)
                HStack {
                    Text("Where would you like to store your recordings?")
                        .font(.system(size: 24, weight: .semibold ))
                        .multilineTextAlignment(.leading)
                        .padding(.trailing)
                        .padding(.leading, 16)
                    Spacer()
                }
                .padding(.bottom, 24)
            
                ICloudDriveButton(iCloudChoose: $iCloudChoose, iPhoneChoose: $iPhoneChoose)
                OnMyiPhone(iPhoneChoose: $iPhoneChoose, iCloudChoose: $iCloudChoose)
                
                Text("To fully utilize iCall Recorder, we recommend enabling iCloud Drive, allowing your recordings to sync automatically with your Macs, PCs, and other iOS devices")
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
                    .font(.system(size: 15, weight: .regular))
                    .multilineTextAlignment(.center)
                    .padding()
                
                
                Text("You can change the storage location at any time through the app's settings")
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
                    .font(.system(size: 15, weight: .regular))
                    .multilineTextAlignment(.center)
                    .padding(16)
                Spacer()
                
                NavigationLink {
                   VoiceRecordingView()
                } label: {
                    RoundedRectangle(cornerRadius: 24)
                        .frame(height: 56)
                        .foregroundColor(.customPink)
                        .overlay {
                            Text("Continue")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .opacity((iCloudChoose == false && iPhoneChoose == false) ? 0.5 : 1.0)
                }
                .disabled(iCloudChoose == false && iPhoneChoose == false)
                
                
                    .navigationBarBackButtonHidden()
            }
        }
    }
}

#Preview {
    ChoosingStorage()
        .environmentObject(AudioRecorder())
}
