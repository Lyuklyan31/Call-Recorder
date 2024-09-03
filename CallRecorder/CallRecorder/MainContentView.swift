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
            TabView(selection: $selectedTab) {
            CallButtonSubView()
                    .tag(0)
            RecordButtonSubView()
                    .tag(1)
            }
            .tabViewStyle(.page)
            .navigationTitle(selectedTab == 0 ? "Call Recorder" : "Voice Memo")
        }
    }
}

#Preview {
    MainContentView()
}
