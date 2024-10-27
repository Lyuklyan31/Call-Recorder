//
//  CallRecordsButton.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 04.09.2024.
//

import SwiftUI

struct CallRecordsButton: View {
    var body: some View {
        NavigationLink {
            CallSetupView()
        } label: {
            VStack {
                Image(.callRecords)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                
                Text("Call Records")
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
                    .offset(y: 8)
                    .frame(alignment: .leading)
            }
        }
    }
}

#Preview {
    CallRecordsButton()
}
