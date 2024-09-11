//
//  buttonDelete.swift
//  CallRecorder
//
//  Created by Andrii Boichuk on 11.09.2024.
//

import SwiftUI

struct ButtonPlayerDelete: View {
    var action: () -> Void
    var body: some View {
        Button (action: action){
            Image(.trash)
        }
    }
    
}

#Preview {
    ButtonPlayerDelete(action: {})
}
