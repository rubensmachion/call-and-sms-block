import SwiftUI
import AppNavigationKit
import CallKit

@main
struct AppSpamBlock: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(startOn: Home2Route.start)
        }
    }
}
