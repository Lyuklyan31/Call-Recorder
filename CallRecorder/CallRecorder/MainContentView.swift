
import SwiftUI

struct MainContentView: View {
    @State private var selectedTab = 0
    @State private var showAlert = false
    var body: some View {
        NavigationView {
            ZStack {
                MakeBackgroundView()
                
                VStack {
                    MainNavigationBar(selectedTab: $selectedTab)
                        .padding()
                    
                    MainTabBar(selectedTab: $selectedTab, showAlert: $showAlert)
                    HStack(spacing: 104) {
                        CallRecordsButton()
                        VoiceRecordsButton()
                    }
                    .padding(.vertical, 32)
                }
                if showAlert == true {
                    CallRecorderAlert(showAlert: $showAlert)
                }
            }
        }
    }
}

#Preview {
    MainContentView()
        .environmentObject(AudioRecorder())
        .environmentObject(AudioPlayer())
        .environmentObject(WavesViewModel())
}
