//
//  AddPhoneNumber.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 04.09.2024.
//

import SwiftUI

struct ChooseCountryDialCode: View {
    @ObservedObject private var countryCodeViewModel = CountryCodeViewModel()
    @State private var selectedCode = "+380"
    @FocusState private var hideKeyboard: Bool
    @State var phoneNumber = ""
    
    @State private var isPickerVisible = false
    
    @Binding var selectionCountry: String?
    @Binding var selectionFlag: String?
    @Binding var selectionDialCode: String?
    
    var body: some View {
        VStack {
            HStack {
                Text(selectionCountry ?? "Select")
                Text(selectionFlag ?? "")
                Text(selectionDialCode ?? "")
                
                Spacer()
                
                Image(.countryArrow)
                    .rotationEffect(.degrees(isPickerVisible ? 90 : 0))
            }
            .onTapGesture {
                withAnimation(.snappy) {
                    isPickerVisible.toggle()
                }
            }
            
            if isPickerVisible {
                VStack {
                    ScrollView(.vertical) {
                        ForEach(0..<countryCodeViewModel.codeCountry.count, id: \.self) { item in
                            HStack {
                                Text(countryCodeViewModel.codeCountry[item].name)
                                    .foregroundStyle(selectionCountry == countryCodeViewModel.codeCountry[item].name ? Color.primary : .gray)
                                Text(countryCodeViewModel.codeCountry[item].flag)
                                Text(countryCodeViewModel.codeCountry[item].dialCode)
                                
                                Spacer()
                                
                                if selectionCountry == countryCodeViewModel.codeCountry[item].name {
                                    Image(systemName: "checkmark")
                                        .font(.subheadline)
                                }
                            }
                            .frame(height: 30)
                            .padding(.horizontal)
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    selectionCountry = countryCodeViewModel.codeCountry[item].name
                                    selectionFlag = countryCodeViewModel.codeCountry[item].flag
                                    selectionDialCode = countryCodeViewModel.codeCountry[item].dialCode
                                    isPickerVisible.toggle()
                                }
                            }
                        }
                    }
                }
                .frame(height: 300)
                .transition(.move(edge: .bottom))
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding()
       
    }
}

#Preview {
    AddPhoneNumber(selectionCountry: .constant("Ukraine"), selectionFlag: .constant("🇺🇦"), selectionDialCode: .constant("+380"))
}
