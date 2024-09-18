import SwiftUI

struct ChoosingTagButtons: View {
    @State private var selectedButtons: Set<String> = ["All"]
    @ObservedObject private var tags = TagsManager()
    var onTagSelectionChange: ((Set<String>) -> Void)?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Button {
                    selectedButtons = ["All"]
                    onTagSelectionChange?(selectedButtons)
                } label: {
                    Text("All")
                        .foregroundColor(selectedButtons.contains("All") ? .white : .black)
                        .padding()
                        .frame(height: 36)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .fill(selectedButtons.contains("All") ? Color.pink : Color.white))
                }
                
                Button {
                    toggleTag("Work")
                } label: {
                    Text("Work")
                        .foregroundColor(selectedButtons.contains("Work") ? .white : .black)
                        .padding()
                        .frame(height: 36)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .fill(selectedButtons.contains("Work") ? Color.pink : Color.white))
                }
                
                Button {
                    toggleTag("Home")
                } label: {
                    Text("Home")
                        .foregroundColor(selectedButtons.contains("Home") ? .white : .black)
                        .padding()
                        .frame(height: 36)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .fill(selectedButtons.contains("Home") ? Color.pink : Color.white))
                }
                
                ForEach(tags.tags, id: \.self) { tag in
                    Button {
                        toggleTag(tag)
                    } label: {
                        Text(tag)
                            .foregroundColor(selectedButtons.contains(tag) ? .white : .black)
                            .padding()
                            .frame(height: 36)
                            .background(RoundedRectangle(cornerRadius: 12)
                                .fill(selectedButtons.contains(tag) ? Color.pink : Color.white))
                    }
                }
                
                Spacer()
            }
        }
        .padding()
    }
    
    private func toggleTag(_ tag: String) {
        if selectedButtons.contains("All") {
            selectedButtons.remove("All")
        }
        
        if selectedButtons.contains(tag) {
            selectedButtons.remove(tag)
        } else {
            selectedButtons.insert(tag)
        }
        
        if selectedButtons.isEmpty {
            selectedButtons = ["All"]
        }
        
        onTagSelectionChange?(selectedButtons)
    }
}
