//
//  CallSetupView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 04.09.2024.
//

import SwiftUI

struct CallSetupView: View {
    @ObservedObject var viewModel = ConfirmOTPViewModel()
    @State private var selectedCountry: String? = "Ukraine"
    @State private var selectedFlag: String? = "🇺🇦"
    @State private var selectedDialCode: String? = "+380"
    @AppStorage("uid") var userID: String = ""
    var body: some View {
       
        if userID.isEmpty {
            ZStack {
                MakeBackgroundView()
                
                VStack {
                    NavigationBarSubView(title: "Call Setup")
                    
                    Text("Enter your phone number")
                        .foregroundColor(.primaryExtraDark)
                        .font(.system(size: 19, weight: .medium ))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    ChooseCountryDialCode(viewModel: viewModel, selectionCountry: $selectedCountry, selectionFlag: $selectedFlag, selectionDialCode: $selectedDialCode)
                    
                    PhoneNumberTextField(selectionDialCode: $selectedDialCode, viewModel: viewModel)
                        .padding(.horizontal)
                    
                    Text("Ensure that you can receive SMS on this number so we can send you a code.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primaryExtraDark.opacity(0.5))
                        .padding()
                        .padding(.horizontal, 40)
                    
                    ContinueButton(viewModel: viewModel, selectedDialCode: $selectedDialCode)
                        .padding(.horizontal)
                    
                    Spacer()
                        .navigationBarBackButtonHidden()
                }
            }
        } else {
            
        }
    }
}

#Preview {
    CallSetupView()
}
