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
                    TextField("00000", value: $phoneNumber, format: .number)
                        .keyboardType(.numberPad)
                        .padding()
                        .animation(.easeInOut(duration: 0.08), value: phoneNumber)
                }
        }
    }
}

#Preview {
    PhoneNumberTextField(selectionDialCode: .constant("380"), phoneNumber: .constant(380))
}
