//
//  PlayerSheet.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 09.09.2024.
//

import SwiftUI

struct PlayerSheet: View {
    @Environment(\.dismiss) var dismiss
    var audioURL: URL
    
    var body: some View {
        VStack {
            HStack {
//                ButtonPlayerDelete(action: )
               
                Button {
                    
                } label: {
                    Image(.share)
                }
                
                Button {
                    
                } label: {
                    Image(.favorite)

                }
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(.dismissButton)
                }
                
            }
            .padding()
            Spacer()
        }
    }
}

