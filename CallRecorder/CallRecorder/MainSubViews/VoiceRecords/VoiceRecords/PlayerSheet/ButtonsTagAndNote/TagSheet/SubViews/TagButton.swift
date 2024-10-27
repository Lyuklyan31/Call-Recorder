
import SwiftUI

struct TagButton: View {
    @Binding var isSelected: Bool
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
            isSelected.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .frame(height: 72)
                    .foregroundColor(.white)
                HStack {
                    if isSelected {
                        Image(.checkMarkCustom)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding(.leading, 24)
                    } else {
                        Image(.circleChoosing)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding(.leading, 24)
                    }
                    
                    Text(title)
                        .foregroundColor(.primaryExtraDark)
                        .font(.system(size: 19, weight: .medium))
                        .padding(8)
                    
                    Spacer()
                }
                if isSelected {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(lineWidth: 2)
                        .frame(height: 72)
                        .foregroundColor(.customPink)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    TagButton(isSelected: .constant(true), title: "Home", action: {})
        .environmentObject(AudioRecorder())
}
