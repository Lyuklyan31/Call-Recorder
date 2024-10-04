import SwiftUI

// MARK: - ChoosingTagButtons
struct ChoosingTagButtons: View {
    
    // MARK: - Properties
    @State private var selectedButtons: Set<String> = ["All"]
    @ObservedObject private var tags =  TagsManager()
    var onTagSelectionChange: ((Set<String>) -> Void)?
    
    // MARK: - Body
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // MARK: - "All" Button
                Button {
                    withAnimation(.spring()) {
                        selectedButtons = ["All"]
                    }
                    onTagSelectionChange?(selectedButtons)
                } label: {
                    Text("All")
                        .foregroundColor(selectedButtons.contains("All") ? .white : .black)
                        .padding()
                        .frame(height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedButtons.contains("All") ? Color.pink : Color.white)
                                .shadow(color: selectedButtons.contains("All") ? .pink.opacity(0.3) : .clear, radius: 5)
                        )
                        .scaleEffect(selectedButtons.contains("All") ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: selectedButtons)
                }
                
                // MARK: - Predefined Tags Buttons
                Button {
                    toggleTag("Work")
                } label: {
                    Text("Work")
                        .foregroundColor(selectedButtons.contains("Work") ? .white : .black)
                        .padding()
                        .frame(height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedButtons.contains("Work") ? Color.pink : Color.white)
                                .shadow(color: selectedButtons.contains("Work") ? .pink.opacity(0.3) : .clear, radius: 5)
                        )
                        .scaleEffect(selectedButtons.contains("Work") ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: selectedButtons)
                }
                
                Button {
                    toggleTag("Home")
                } label: {
                    Text("Home")
                        .foregroundColor(selectedButtons.contains("Home") ? .white : .black)
                        .padding()
                        .frame(height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedButtons.contains("Home") ? Color.pink : Color.white)
                                .shadow(color: selectedButtons.contains("Home") ? .pink.opacity(0.3) : .clear, radius: 5)
                        )
                        .scaleEffect(selectedButtons.contains("Home") ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: selectedButtons)
                }
                
                // MARK: - Dynamic Tags from TagsManager
                ForEach(tags.tags, id: \.self) { tag in
                    Button {
                        toggleTag(tag)
                    } label: {
                        Text(tag)
                            .foregroundColor(selectedButtons.contains(tag) ? .white : .black)
                            .padding()
                            .frame(height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedButtons.contains(tag) ? Color.pink : Color.white)
                                    .shadow(color: selectedButtons.contains(tag) ? .pink.opacity(0.3) : .clear, radius: 5)
                            )
                            .scaleEffect(selectedButtons.contains(tag) ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: selectedButtons)
                    }
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
        }
    }
    
    // MARK: - Helper Methods
    private func toggleTag(_ tag: String) {
        withAnimation(.spring()) {
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
}
