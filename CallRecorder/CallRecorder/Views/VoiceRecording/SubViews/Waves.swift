//
//  Waves.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 06.09.2024.
//

import SwiftUI

struct Waves: View {
    var body: some View {
        ZStack {
            VStack {
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.customPink)
                    .bold()
                Spacer()
            }
            LinearGradient(
                gradient: Gradient(colors: [.customPink.opacity(0.4), .backraundWhite]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    Waves()
}
