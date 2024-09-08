//
//  ButtonSetting.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 07.09.2024.
//

import SwiftUI

struct ButtonSetting<Destination: View>: View {
    var image: String
    var text: String
    var destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .foregroundColor(.white)
                    .frame(height: 64)
                
                HStack {
                    Image(image)
                        .padding(.horizontal)
                    Text(text)
                        .font(.system(size: 19))
                        .bold()
                        .foregroundColor(.black)
                    Spacer()
                    Image(.arrowRight)
                        .padding(.horizontal)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ButtonSetting(image: "rateUs", text: "Text", destination: Text("Destination View"))
}
