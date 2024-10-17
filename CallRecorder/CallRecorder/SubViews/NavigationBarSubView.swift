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
                Spacer()
            }
            
            Text(title)
                .font(.system(size: 19, weight: .medium))
                .bold()
                .foregroundColor(.primary)
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationBarSubView(title: "title")
}
