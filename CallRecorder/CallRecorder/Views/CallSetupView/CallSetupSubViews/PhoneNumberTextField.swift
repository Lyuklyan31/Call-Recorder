//
//  PhoneNumverTextField.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 05.09.2024.
//

import SwiftUI

struct PhoneNumberTextField: View {
    @Binding var selectionDialCode: String?
    @State var phoneNumber: String = ""
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 24)
                .frame(width: 88, height: 56)
                .foregroundColor(.white)
                .overlay {
                    Text(selectionDialCode ?? "")
                }
            
            RoundedRectangle(cornerRadius: 24)
                .foregroundColor(.white)
                .frame(height: 56)
                .overlay {
                    TextField("0", text: $phoneNumber)
                }
        }
    }
}

#Preview {
    PhoneNumverTextField(selectionDialCode: .constant("380"))
}
