import UIKit
import NetworkKit

class AppDelegate: NSObject, UIApplicationDelegate {

    private lazy var blackListRefresh: IAppBackgroundTaskManager = {
        let network = NetworkRequest()
        let service = AppBackgroundRefreshService(network: network)
        let dataStore = DataStore()
        let bg = AppBackgroundTaskManager(service: service, dataStore: dataStore)
        return bg
    }()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        _ = AppCallDirectoryProvider.shared
        _ = blackListRefresh

        return true
    }

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        let sceneConfig: UISceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}
