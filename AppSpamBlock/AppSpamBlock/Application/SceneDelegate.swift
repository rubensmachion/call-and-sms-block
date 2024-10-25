import UIKit

class SceneDelegate: NSObject {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo
               session: UISceneSession, options
               connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else {return}

        print(scene)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }
}
