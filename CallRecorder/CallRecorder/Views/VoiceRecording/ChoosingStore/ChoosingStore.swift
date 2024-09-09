//
//  ChoosingStore.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 08.09.2024.
//

import SwiftUI

struct ChoosingStore: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.backraundWhite, .backraundPink]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            VStack {
                NavigationBarSubView(title: "Records Storage")
                    .padding(.bottom, 24)
                HStack {
                    Text("Where would you like to store your recordings?")
                        .font(.system(size: 24, weight: .semibold ))
                        .multilineTextAlignment(.leading)
                        .padding(.trailing)
                        .padding(.leading, 16)
                       Spacer()
                }
                Spacer()
                    .navigationBarBackButtonHidden()
            }
        }
    }
}

#Preview {
    ChoosingStore()
}
