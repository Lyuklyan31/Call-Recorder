import SwiftUI

@main
struct CallRecorderApp: App {
    var body: some Scene {
        WindowGroup {
            MainContentView()
                .environmentObject(AudioRecorder())
                .environmentObject(WavesViewModel())
                .environmentObject(AudioPlayer())
        }
    }
}
