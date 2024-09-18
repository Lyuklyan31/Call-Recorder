

import SwiftUI

struct MakeBackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [.backraundWhite, .backraundPink]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
        
    }
}

#Preview {
    MakeBackgroundView()
}
