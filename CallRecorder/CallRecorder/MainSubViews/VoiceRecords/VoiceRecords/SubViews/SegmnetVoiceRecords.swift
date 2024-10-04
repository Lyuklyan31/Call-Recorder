import SwiftUI

// MARK: - SegmentVoiceRecords
struct SegmentVoiceRecords: View {
    
    // MARK: - Properties
    @Binding var selection: Int
    
    // MARK: - Body
    var body: some View {
        VStack {
            Picker("Voice Records", selection: $selection) {
                Text("All").tag(0)
                Text("Starred").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
        }
    }
}

// MARK: - Preview
#Preview {
    SegmentVoiceRecords(selection: .constant(0))
}
