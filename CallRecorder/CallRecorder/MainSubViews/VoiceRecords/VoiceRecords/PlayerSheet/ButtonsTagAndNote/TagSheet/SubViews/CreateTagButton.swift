import SwiftUI

struct CreateTagButton: View {
    @State private var isActive = false
    @Binding var newTag: String
    var action: () -> Void
    
    var body: some View {
        Button {
            isActive = true
        } label: {
            RoundedRectangle(cornerRadius: 24)
                .stroke(lineWidth: 2)
                .foregroundColor(.customPink)
                .frame(width: 214, height: 56)
                .overlay {
                    HStack {
                        Image(.plus)
                        
                        Text("Create Tag")
                            .foregroundColor(.customPink)
                            .font(.system(size: 19, weight: .medium))
                    }
                }
        }
        .alert("Create Tag", isPresented: $isActive) {
            TextField("Enter tag", text: $newTag)
                .textInputAutocapitalization(.never)
            
            Button("Cancel", role: .cancel) {
                isActive = false
            }
            
            Button("Save", role: .none) {
                if !newTag.isEmpty {
                    action()
                    isActive = false
                }
            }
        } message: {
            Text("0/15 characters")
        }
    }
}

#Preview {
    CreateTagButton(newTag: .constant(""), action: {})
}
