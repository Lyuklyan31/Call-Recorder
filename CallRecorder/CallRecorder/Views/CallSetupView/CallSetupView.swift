//
//  CallSetupView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 04.09.2024.
//

import SwiftUI

struct CallSetupView: View {
    var body: some View {
        VStack {
            CallSetupNavigationBar()
            
            Text("Enter your phone number")
                .font(.system(size: 19, weight: .medium ))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            Spacer()
                .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    CallSetupView()
}
