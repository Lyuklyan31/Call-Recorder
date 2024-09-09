//
//  ICloudDriveButton.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 08.09.2024.
//

import SwiftUI

struct OnMyiPhone: View {
    @Binding var iPhoneChoose: Bool
    @Binding var iCloudChoose: Bool
    var body: some View {
            Button {
                iPhoneChoose.toggle()
                changeChoose()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .frame(height: 72)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    HStack {
                        Text("On my iPhone")
                            .foregroundColor(.black)
                            .font(.system(size: 19, weight: .medium))
                            .padding(.leading, 40)
                        Spacer()
                        
                        if iPhoneChoose == true {
                            Image(.checkMarkCustom)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24,height: 24)
                                .padding(.trailing, 40)
                            
                        } else {
                            Image(.circleChoosing)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24,height: 24)
                                .padding(.trailing, 40)
                        }
                    }
                    if iPhoneChoose == true {
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(lineWidth: 2)
                            .frame(height: 72)
                            .foregroundColor(.customPink)
                            .padding(.horizontal)
                    }
                }
            }
        }
    private func changeChoose() {
        if iPhoneChoose == true {
            iCloudChoose = false
        }
    }
}

#Preview {
    OnMyiPhone(iPhoneChoose: .constant(false), iCloudChoose: .constant(false))
}
