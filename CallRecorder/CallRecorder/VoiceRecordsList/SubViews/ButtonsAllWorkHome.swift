//
//  ButtonsAllWorkHome.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 05.09.2024.
//

import SwiftUI

struct ButtonsAllWorkHome: View {
    @State private var selectedButton: Int = 0
    
    var body: some View {
        HStack {
            Button {
                selectedButton = 0
            } label: {
                Text("All")
                    .foregroundColor(selectedButton == 0 ? .white : .black)
                    .padding()
                    .frame(height: 36)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(selectedButton == 0 ? Color.pink : Color.white))
            }
            
            Button {
                selectedButton = 1
            } label: {
                Text("Work")
                    .foregroundColor(selectedButton == 1 ? .white : .black)
                    .padding()
                    .frame(height: 36)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(selectedButton == 1 ? Color.pink : Color.white))
            }
            
            Button {
                selectedButton = 2
            } label: {
                Text("Home")
                    .foregroundColor(selectedButton == 2 ? .white : .black)
                    .padding()
                    .frame(height: 36)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(selectedButton == 2 ? Color.pink : Color.white))
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ButtonsAllWorkHome()
}
