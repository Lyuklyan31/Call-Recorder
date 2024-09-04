//
//  TabBarSubView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 04.09.2024.
//

import SwiftUI

struct MainTabBar: View {
    @Binding var selectedTab: Int
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                CallButton()
                    .tag(0)
                    
                RecordButton()
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
    MainTabBar(selectedTab: .constant(0))
}
