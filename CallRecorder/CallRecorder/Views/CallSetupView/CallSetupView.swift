//
//  CallSetupView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 04.09.2024.
//

import SwiftUI

struct CallSetupView: View {
    @State private var selectedCountry: String? = "Ukraine"
    @State private var selectedFlag: String? = "🇺🇦"
    @State private var selectedDialCode: String? = "+380"
    @State private var phoneNumber: Int?
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.backraundWhite, .backraundPink]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                CallSetupNavigationBar()
                
                Text("Enter your phone number")
                    .foregroundColor(.primaryExtraDark)
                    .font(.system(size: 19, weight: .medium ))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                ChooseCountryDialCode(selectionCountry: $selectedCountry, selectionFlag: $selectedFlag, selectionDialCode: $selectedDialCode)
                
                PhoneNumberTextField(selectionDialCode: $selectedDialCode, phoneNumber: $phoneNumber)
                    .padding(.horizontal)
                
                Text("Ensure that you can receive SMS on this number so we can send you a code.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
                    .padding()
                    .padding(.horizontal, 40)
                    
                ContinueButton(amountNumbers: $phoneNumber)
                    .padding(.horizontal)
                Spacer()
                    .navigationBarBackButtonHidden()
            }
        }
    }
}

#Preview {
    CallSetupView()
}
