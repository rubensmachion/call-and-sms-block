import SwiftUI
import CallKit

@main
struct CallSMSBlockApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            TabView {
                AppCoordinatorView(startOn: Home2Route.start)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                AppCoordinatorView(startOn: HomeRoute.start)
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("Home")
                    }
                AppCoordinatorView(startOn: SearchRoute.start)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                AppCoordinatorView(startOn: SettingsRoute.start)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
        }
    }
}
