//
//  ContentView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 03.09.2024.
//

import SwiftUI

struct MainContentView: View {
    @State private var selectedTab = 0
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.backraundWhite, .backraundPink]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    MainNavigationBar(selectedTab: $selectedTab)
                        .padding()
                    
                    MainTabBar(selectedTab: $selectedTab)
                    HStack(spacing: 104) {
                        CallRecordsButton()
                        VoiceRecordsButton()
                    }
                    .padding(.vertical, 32)
                }
            }
        }
    }
}

#Preview {
    MainContentView()
        .environmentObject(AudioRecorder())
        .environmentObject(WavesViewModel())
}
