//
//  PlayerSheet.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 09.09.2024.
//

import SwiftUI

struct PlayerSheet: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            HStack {
                Button {
                    
                } label: {
                    Image(.trash)
                }
               
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

#Preview {
    PlayerSheet()
}
