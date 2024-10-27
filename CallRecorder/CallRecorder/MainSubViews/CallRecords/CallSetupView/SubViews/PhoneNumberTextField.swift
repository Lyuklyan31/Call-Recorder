//
//  PhoneNumverTextField.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 05.09.2024.
//

import SwiftUI

struct PhoneNumberTextField: View {
    @Binding var selectionDialCode: String?
    var contentType: UITextContentType = .telephoneNumber
    @ObservedObject var viewModel: ConfirmOTPViewModel
    
    var body: some View {
        HStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 24)
                .frame(width: 88, height: 56)
                .foregroundColor(.white)
                .overlay {
                    Text(selectionDialCode ?? "")
                        .padding()
                        .animation(.easeInOut(duration: 0.08), value: selectionDialCode)
                }
            
            RoundedRectangle(cornerRadius: 24)
                .foregroundColor(.white)
                .frame(height: 56)
                .overlay {
                    TextField("00000", text: $viewModel.phoneNumber)
                        .textContentType(contentType)
                        .keyboardType(.numberPad)
                        .padding()
                        .animation(.easeInOut(duration: 0.08), value: viewModel.phoneNumber)
                }
        }
    }
}

#Preview {
    PhoneNumberTextField(selectionDialCode: .constant("+380"), viewModel: ConfirmOTPViewModel())
}
