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
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MainContentView()
}
