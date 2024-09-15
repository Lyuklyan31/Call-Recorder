//
//  TagButton.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 15.09.2024.
//

import SwiftUI

struct TagButton: View {
    @Binding var chooseTag: Bool
    @State var title: String
    
    var body: some View {
        Button {
            chooseTag.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .frame(height: 72)
                    .foregroundColor(.white)
                HStack {
                    if chooseTag == true {
                        Image(.checkMarkCustom)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24,height: 24)
                            .padding(.leading, 24)
                    } else {
                        Image(.circleChoosing)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24,height: 24)
                            .padding(.leading, 24)
                    }
                    
                    Text(title)
                        .foregroundColor(.primaryExtraDark)
                        .font(.system(size: 19, weight: .medium))
                        .padding(8)
                    
                    Spacer()
                }
                if chooseTag == true {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(lineWidth: 2)
                        .frame(height: 72)
                        .foregroundColor(.customPink)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    TagButton(chooseTag: .constant(true), title: "Home")
}
