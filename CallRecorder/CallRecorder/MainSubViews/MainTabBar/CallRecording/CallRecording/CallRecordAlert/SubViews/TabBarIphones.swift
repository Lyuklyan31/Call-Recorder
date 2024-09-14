//
//  TabBarIphones.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 09.09.2024.
//

import SwiftUI

struct TabBarIphones: View {
    @Binding var selectedTab: Int
    var body: some View {
        TabView(selection: $selectedTab) {
           IPhone(image: "iPhoneFirst")
                .tag(0)
                
            IPhone(image: "iPhoneSecond")
                .tag(1)
        }
        .tabViewStyle(.page)
        .onAppear {
            UIPageControl.appearance().isHidden = true
        }
    }
}

#Preview {
    TabBarIphones(selectedTab: .constant(0))
}
