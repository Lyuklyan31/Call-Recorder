//
//  VoiceRecordsButton.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 04.09.2024.
//

import SwiftUI

struct VoiceRecordsButton: View {
    var body: some View {
        NavigationLink {
            VoiceRecordsList()
        } label: {
            VStack {
                Image(.voiceRecords)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                
                Text("Voice Records")
                    .foregroundColor(.primaryExtraDark.opacity(0.5))
                    .offset(y: 8)
                    .frame(alignment: .leading)
            }
        }
    }
}

#Preview {
    VoiceRecordsButton()
}
