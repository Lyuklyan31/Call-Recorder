import SwiftUI

struct ChoosingTagButtons: View {
    @State private var selectedButtons: Set<Int> = [0]
    @ObservedObject private var tags = TagsManager()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Button {
                    selectedButtons = [0]
                } label: {
                    Text("All")
                        .foregroundColor(selectedButtons.contains(0) ? .white : .black)
                        .padding()
                        .frame(height: 36)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .fill(selectedButtons.contains(0) ? Color.pink : Color.white))
                }
                
                Button {
                    toggleTag(1)
                } label: {
                    Text("Work")
                        .foregroundColor(selectedButtons.contains(1) ? .white : .black)
                        .padding()
                        .frame(height: 36)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .fill(selectedButtons.contains(1) ? Color.pink : Color.white))
                }
                
                Button {
                    toggleTag(2)
                } label: {
                    Text("Home")
                        .foregroundColor(selectedButtons.contains(2) ? .white : .black)
                        .padding()
                        .frame(height: 36)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .fill(selectedButtons.contains(2) ? Color.pink : Color.white))
                }
                
                ForEach(tags.tags.indices, id: \.self) { index in
                    Button {
                        toggleTag(index + 3)
                    } label: {
                        Text(tags.tags[index])
                            .foregroundColor(selectedButtons.contains(index + 3) ? .white : .black)
                            .padding()
                            .frame(height: 36)
                            .background(RoundedRectangle(cornerRadius: 12)
                                .fill(selectedButtons.contains(index + 3) ? Color.pink : Color.white))
                    }
                }
                
                Spacer()
            }
        }
        .padding()
    }
    
    private func toggleTag(_ tag: Int) {
        if selectedButtons.contains(0) {
            selectedButtons.remove(0)
        }
        
        if selectedButtons.contains(tag) {
            selectedButtons.remove(tag)
        } else {
            selectedButtons.insert(tag)
        }
        
        if selectedButtons.isEmpty {
            selectedButtons = [0]
        }
    }
}

#Preview {
    ChoosingTagButtons()
}
