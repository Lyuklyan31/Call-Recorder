import SwiftUI
import FirebaseCore
import FirebaseAuth


@main
struct CallRecorderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            MainContentView()
                .environmentObject(AudioRecorder())
                .environmentObject(WavesViewModel())
                .environmentObject(AudioPlayer())
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
    
    //MARK: Phone Auth Needs to Intialize Remote Notifcations
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
            return .noData
        }
}
