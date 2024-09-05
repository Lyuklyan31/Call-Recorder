//
//  OTPLine.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 05.09.2024.
//

import SwiftUI

struct OTPLine: View {
    @ObservedObject var viewModel = ConfirmOTPViewModel()
    @State var isFocused = false
    
    let textBoxWidth = UIScreen.main.bounds.width / 8
    let textBoxHeight = UIScreen.main.bounds.width / 8
    let spaceBetweenBoxes: CGFloat = 10
    let paddingOfBox: CGFloat = 1
    var textFieldOriginalWidth: CGFloat {
        (textBoxWidth*6)+(spaceBetweenBoxes*3)+((paddingOfBox*2)*3)
    }
    
    @State var isActive: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                HStack(spacing: spaceBetweenBoxes) {
                    otpText(text: viewModel.otp1)
                    otpText(text: viewModel.otp2)
                    otpText(text: viewModel.otp3)
                    otpText(text: viewModel.otp4)
                    otpText(text: viewModel.otp5)
                    otpText(text: viewModel.otp6)
                }
                
                TextField("", text: $viewModel.otpField)
                    .frame(width: isFocused ? 0 : textFieldOriginalWidth, height: textBoxHeight)
                    .disabled(viewModel.isTextFieldDisabled)
                    .textContentType(.oneTimeCode)
                    .foregroundColor(.clear)
                    .accentColor(.clear)
                    .background(Color.clear)
                    .keyboardType(.numberPad)
            }
        }
        .padding(.bottom, 48)
        
        if viewModel.timerIsRunning {
            Text("Resend SMS after...\(viewModel.remainingTime)")
                .foregroundColor(.primaryExtraDark.opacity(0.5))
        } else {
            Button(role: .destructive) {
                viewModel.startTimer()
            } label: {
                Text("Resend SMS")
            }
        }
    }
    
    private func otpText(text: String) -> some View {
        let displayText = text.isEmpty ? "0" : text
        let textColor = text.isEmpty ? Color.gray : Color.black
        
        return Text(displayText)
            .font(.title)
            .multilineTextAlignment(.center)
            .foregroundColor(textColor)
            .frame(width: textBoxWidth, height: textBoxHeight)
            .background(VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 56, height: 56)
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
            })
            .padding(paddingOfBox)
          
    }
}

#Preview {
    OTPLine()
}
