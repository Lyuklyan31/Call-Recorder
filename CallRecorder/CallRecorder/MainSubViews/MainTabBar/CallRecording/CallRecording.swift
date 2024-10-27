//
//  CallButtonSubView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 04.09.2024.
//

import SwiftUI

struct CallRecording: View {
    
    @Binding var showAlert: Bool
    @AppStorage("uid") var userID: String = ""
    var body: some View {
        
        if userID.isEmpty {
            ZStack {
                Button {
                    showAlert = true
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 240)
                            .foregroundColor(.customPink.opacity(0.1))
                            .blur(radius: 1.2)
                            .shadow(radius: 2)
                        
                        Circle()
                            .frame(width: 192)
                            .foregroundColor(.customPink.opacity(0.1))
                            .blur(radius: 1.2)
                            .shadow(radius: 2)
                        
                        Circle()
                            .frame(width: 142)
                            .foregroundColor(.white)
                        
                        Image(.phone)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                    }
                }
            }
        } else {
            ZStack {
                Link( destination: URL(string: "tel://+12099353165")!){
                    ZStack {
                        Circle()
                            .frame(width: 240)
                            .foregroundColor(.customPink.opacity(0.1))
                            .blur(radius: 1.2)
                            .shadow(radius: 2)
                        
                        Circle()
                            .frame(width: 192)
                            .foregroundColor(.customPink.opacity(0.1))
                            .blur(radius: 1.2)
                            .shadow(radius: 2)
                        
                        Circle()
                            .frame(width: 142)
                            .foregroundColor(.white)
                        
                        Image(.phone)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                    }
                }
            }
        }
    }
}


//struct test: View {
//    var body: some View {
//        
//    }
//}

    #Preview {
        CallRecording(showAlert: .constant(false))
    }
