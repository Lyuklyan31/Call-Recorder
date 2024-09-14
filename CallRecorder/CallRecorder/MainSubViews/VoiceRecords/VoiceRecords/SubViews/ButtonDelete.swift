import SwiftUI

struct ButtonDelete: View {
    var action: () -> Void
    
    var body: some View {
        Button(role: .destructive, action: action) {
            Image(.trashForSwipe)
        }
    }
}

#Preview {
    ButtonDelete(action: {})
}
