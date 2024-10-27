//
//  ContinueButton.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 05.09.2024.
//

import SwiftUI

struct ContinueButton: View {

    @ObservedObject var viewModel: ConfirmOTPViewModel
    
    @Binding var selectedDialCode: String?
    var body: some View {
        VStack {
            NavigationLink {
                ConfirmOTPcodeView(selectedDialCode: $selectedDialCode, viewModel: viewModel)
            } label: {
                RoundedRectangle(cornerRadius: 24)
                    .frame(height: 56)
                    .foregroundColor(.customPink)
                    .overlay {
                        Text("Continue")
                            .foregroundColor(.white)
                    }
                    .opacity((String(viewModel.phoneNumber).count > 8) ? 1.0 : 0.5)
            }
            .disabled(String(viewModel.phoneNumber).count < 8)
        }
    }
}

#Preview {
    ContinueButton(viewModel: ConfirmOTPViewModel(), selectedDialCode: .constant("+380"))
}
