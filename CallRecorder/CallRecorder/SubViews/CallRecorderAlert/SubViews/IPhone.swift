//
//  IPhoneOne.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 09.09.2024.
//

import SwiftUI

struct IPhoneOne: View {
    var image: String
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFill()
            .offset(y: -60)
            .frame(width: 276, height: 235)
            .mask(LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.black.opacity(7), location: 0),
                    .init(color: Color.black.opacity(0), location: 1)
                ]),
                startPoint: .bottom, endPoint: .top)
            )
    }
}

#Preview {
    IPhoneOne(image: "iPhone")
}
