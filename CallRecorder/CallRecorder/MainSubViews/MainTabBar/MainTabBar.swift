//
//  TabBarSubView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 04.09.2024.
//

import SwiftUI

struct MainTabBar: View {
    @Binding var selectedTab: Int
    @Binding var showAlert: Bool
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                
                CallRecording(showAlert: $showAlert)
                    .tag(0)
                    
                VoiceRecordingButton()
                    .tag(1)
            }
            .tabViewStyle(.page)
            .onAppear {
                UIPageControl.appearance().isHidden = true
            }
        }
    }
}

#Preview {
    MainTabBar(selectedTab: .constant(0), showAlert: .constant(false))
}
