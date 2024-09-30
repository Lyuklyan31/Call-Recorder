
import SwiftUI

struct NavigationBarSubView: View {
    @Environment(\.dismiss) var dismiss
    @State var title: String
    var body: some View {
        HStack {
            VStack {
                ZStack {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(.arrowBack)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                            Spacer()
                        }
                    }
                    Text(title)
                        .font(.system(size: 19, weight: .medium ))
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.primaryExtraDark)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationBarSubView(title: "title")
}
