//
//  SwipeProgress.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 09.09.2024.
//

import SwiftUI

struct SwipeProgress: View {
    @Binding var selectedTab: Int
    var body: some View {
        HStack {
            Spacer()
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

#Preview {
    SwipeProgress(selectedTab: .constant(0))
}
