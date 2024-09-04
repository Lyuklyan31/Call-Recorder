//
//  TabBarSubView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 04.09.2024.
//

import SwiftUI

struct MainTabBarSubView: View {
    @Binding var selectedTab: Int
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                CallButtonSubView()
                    .tag(0)
                    
                RecordButtonSubView()
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
    MainTabBarSubView(selectedTab: .constant(0))
}
