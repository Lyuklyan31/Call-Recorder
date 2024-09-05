//
//  PhoneNumverTextField.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 05.09.2024.
//

import SwiftUI

struct PhoneNumberTextField: View {
    @Binding var selectionDialCode: String?
    @Binding var phoneNumber: Int?
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 24)
                .frame(width: 88, height: 56)
                .foregroundColor(.white)
                .overlay {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        Text(selectionDialCode ?? "")
                            .padding()
                    }
                }
            
            RoundedRectangle(cornerRadius: 24)
                .foregroundColor(.white)
                .frame(height: 56)
                .overlay {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        TextField("00000", value: $phoneNumber, format: .number)
                            .keyboardType(.numberPad)
                            .padding()
                    }
                }
        }
    }
}

#Preview {
    PhoneNumberTextField(selectionDialCode: .constant("380"), phoneNumber: .constant(+380))
}
