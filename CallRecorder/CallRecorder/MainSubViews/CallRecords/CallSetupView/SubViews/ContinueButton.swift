//
//  ContinueButton.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 05.09.2024.
//

import SwiftUI

struct ContinueButton: View {
    @Binding var amountNumbers: Int?
    
    var body: some View {
        VStack {
            NavigationLink {
                ConfirmOTPcodeView(phoneNumber: $amountNumbers)
            } label: {
                RoundedRectangle(cornerRadius: 24)
                    .frame(height: 56)
                    .foregroundColor(.customPink)
                    .overlay {
                        Text("Continue")
                            .foregroundColor(.white)
                    }
                    .opacity((String(amountNumbers ?? 0).count > 8) ? 1.0 : 0.5)
            }
            .disabled(String(amountNumbers ?? 0).count < 8)
        }
    }
}

#Preview {
    ContinueButton(amountNumbers: .constant(10))
}
