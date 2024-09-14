//
//  ConfirmOTPcode.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 05.09.2024.
//

import SwiftUI

struct ConfirmOTPcodeView: View {
    @Binding var phoneNumber: Int?
   
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.backraundWhite, .backraundPink]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                NavigationBarSubView(title: "Confirm Your Number")
                    .padding(.bottom, 32)
                
                Text("We’ve sent a code by SMS to phone number")
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
                
                Text(String(phoneNumber ?? 0))
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
                
                Button(role: .destructive) {
                    
                } label: {
                    Text("Wrong number?")
                }
                .padding(.bottom, 88)
                
                Text("Enter your code")
                    .font(.system(size: 28))
                    .bold()
                
                OTPLine()
                
                Spacer()
                    .navigationBarBackButtonHidden()
            }
        }
    }
}

#Preview {
    ConfirmOTPcodeView(phoneNumber: .constant(+380986684323))
}
