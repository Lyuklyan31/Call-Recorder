//
//  SettingView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 07.09.2024.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        ZStack {
            MakeBackgroundView()
            
            
            
            VStack {
                NavigationBarSubView(title: "Settings")
                ButtonSetting(image: "shareApp", text: "Share App", destination: WaveView())
                
                ButtonSetting(image: "restorePurchases", text: "Restore Purchases", destination: WaveView())
                
                ButtonSetting(image: "rateUs", text: "Rate Us", destination: WaveView())
                
                ButtonSetting(image: "contactUs", text: "Contact Us", destination: WaveView())
                
                ButtonSetting(image: "termsOfUse", text: "Terms of Use", destination: WaveView())
                
                ButtonSetting(image: "privacyPolicy", text: "Privacy Policy", destination: WaveView())
                Spacer()
                Button {
                    Task {
                        do {
                            try AuthennticationManager.shared.signOut()
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Singout")
                }
                    .navigationBarBackButtonHidden()
            }
        }
    }
}

#Preview {
    SettingView()
}
