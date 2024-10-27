//
//  ConfirmOTPcode.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 05.09.2024.
//

import SwiftUI

struct ConfirmOTPcodeView: View {
    @Binding var selectedDialCode: String?
    @ObservedObject var viewModel: ConfirmOTPViewModel
    var body: some View {
        let fullPhoneNumber = viewModel.selectedDialCode + viewModel.phoneNumber
        ZStack {
            MakeBackgroundView()
            
            VStack {
                NavigationBarSubView(title: "Confirm Your Number")
                    .padding(.bottom, 32)
                
                Text("We’ve sent a code by SMS to phone number")
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
                
                Text(fullPhoneNumber)
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
                
                Button(role: .destructive) {
                    
                } label: {
                    Text("Wrong number?")
                }
                .padding(.bottom, 88)
                
                Text("Enter your code")
                    .font(.system(size: 28))
                    .bold()
                
                OTPLine(viewModel: viewModel)
                
                Spacer()
                    .navigationBarBackButtonHidden()
            }
        }
    }
}

#Preview {
    ConfirmOTPcodeView(selectedDialCode: .constant("+380"), viewModel: ConfirmOTPViewModel())
}
