import SwiftUI

struct NavigationBarSubView: View {
    @Environment(\.dismiss) var dismiss
    @State var title: String
    
    var body: some View {
        ZStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(.arrowBack)
                }
                Spacer()
            }
            
            Text(title)
                .font(.system(size: 19, weight: .medium))
                .bold()
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    NavigationBarSubView(title: "title")
}
