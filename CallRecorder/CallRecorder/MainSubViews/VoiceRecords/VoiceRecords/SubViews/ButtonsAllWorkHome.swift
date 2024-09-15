import SwiftUI

struct ButtonsAllWorkHome: View {
    @State var selectedButton: Int
    @ObservedObject private var tags = TagsManager()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
        HStack {
                Button {
                    selectedButton = 0
                } label: {
                    Text("All")
                        .foregroundColor(selectedButton == 0 ? .white : .black)
                        .padding()
                        .frame(height: 36)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .fill(selectedButton == 0 ? Color.pink : Color.white))
                }
                
                Button {
                    selectedButton = 1
                } label: {
                    Text("Work")
                        .foregroundColor(selectedButton == 1 ? .white : .black)
                        .padding()
                        .frame(height: 36)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .fill(selectedButton == 1 ? Color.pink : Color.white))
                }
                
                Button {
                    selectedButton = 2
                } label: {
                    Text("Home")
                        .foregroundColor(selectedButton == 2 ? .white : .black)
                        .padding()
                        .frame(height: 36)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .fill(selectedButton == 2 ? Color.pink : Color.white))
                }
                
            ForEach(tags.tags, id: \.self) { tag in
                    Button {
                        if tag == "Home" {
                            selectedButton = 2
                        } else if tag == "Work" {
                            selectedButton = 1
                        } else {
                            selectedButton = TagsManager.shared.tags.count+3
                        }
                    } label: {
                        Text(tag)
                            .foregroundColor(selectedButton == tags.tags.count+3 ? .white : .black)
                            .padding()
                            .frame(height: 36)
                            .background(RoundedRectangle(cornerRadius: 12)
                                .fill(selectedButton == tags.tags.count+3 ? Color.pink : Color.white))
                    }
                }
                
                Spacer()
            }
        }
            .padding()
    }
}

#Preview {
    ButtonsAllWorkHome(selectedButton: 0)
}
