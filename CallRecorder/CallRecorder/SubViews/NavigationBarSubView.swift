//
//  NavigationBarSubView.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 04.09.2024.
//

import SwiftUI

struct NavigationBarSubView: View {
    @Environment(\.dismiss) var dismiss
    @State var title: String
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
                    Text(title)
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
    NavigationBarSubView(title: "title")
}
