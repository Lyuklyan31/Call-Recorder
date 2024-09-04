//
//  NavigationBarSubView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 04.09.2024.
//

import SwiftUI

struct CallSetupNavigationBar: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        HStack {
            VStack {
                ZStack {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(.arrowBack)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                            Spacer()
                        }
                    }
                    Text("Call Setup")
                        .font(.system(size: 19, weight: .bold ))
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.primaryExtraDark)
                }
            }
        }
    }
}

#Preview {
    CallSetupNavigationBar()
}
