//
//  NavigationBarSubView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 04.09.2024.
//

import SwiftUI

struct MainNavigationBar: View {
    @Binding var selectedTab: Int
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    if selectedTab == 0 {
                        Text("Call Recorder")
                            .font(.largeTitle)
                            .bold()
                            .transition(.opacity.combined(with: .scale))
                    } else {
                        Text("Voice Memo")
                            .font(.largeTitle)
                            .bold()
                            .transition(.opacity.combined(with: .scale))
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: selectedTab)
                
                Spacer()
                NavigationLink {
                    SettingView()
                } label: {
                    Image(.setting)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                    
                }
            }
            
            HStack {
                ForEach(0..<2) { index in
                    Capsule()
                        .frame(width: selectedTab == index ? 24 : 8, height: 8)
                        .foregroundColor(.customPink.opacity(selectedTab == index ? 1.0 : 0.2))
                        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.8), value: selectedTab)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    MainNavigationBar(selectedTab: .constant(0))
}
