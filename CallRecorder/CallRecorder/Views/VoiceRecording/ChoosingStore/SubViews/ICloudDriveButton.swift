//
//  ICloudDriveButton.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 08.09.2024.
//

import SwiftUI

struct ICloudDriveButton: View {
    @Binding var iCloudChoose: Bool
    @Binding var iPhoneChoose: Bool
    
    var body: some View {
        Button {
            iCloudChoose.toggle()
            changeChoose()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .frame(height: 72)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                HStack {
                    Text("iCloud Drive")
                        .foregroundColor(.black)
                        .font(.system(size: 19, weight: .medium))
                        .padding(.leading, 40)
                    Spacer()
                    
                    if iCloudChoose == true {
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
                if iCloudChoose == true {
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
        if iCloudChoose == true {
            iPhoneChoose = false
        }
    }
}

#Preview {
    ICloudDriveButton(iCloudChoose: .constant(false), iPhoneChoose: .constant(false))
}
