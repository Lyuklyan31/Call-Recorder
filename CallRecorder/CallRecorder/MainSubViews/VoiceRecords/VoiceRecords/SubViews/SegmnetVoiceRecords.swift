//
//  SegmnetVoiceRecords.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 05.09.2024.
//

import SwiftUI

struct SegmnetVoiceRecords: View {
    @Binding var selection: Int
    var body: some View {
        VStack {
            Picker("What is your favorite color?", selection: $selection) {
                Text("All").tag(0)
                Text("Starred").tag(1)
                
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
        }
    }
}

#Preview {
    SegmnetVoiceRecords(selection: .constant(0))
}
