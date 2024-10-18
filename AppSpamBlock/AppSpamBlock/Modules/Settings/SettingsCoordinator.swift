import Foundation
import AppNavigationKit

protocol SettingsCoordinatorProtocol {
    func pushSomeScreen()
    func presentSomeScreen()
    func fullScreenCover()
}

final class SettingsCoordinator: SettingsCoordinatorProtocol {

    // MARK: - Properties

    private let appCoordinator: any AppCoordinatorProtocol

    // MARK: - Init

    init(appCoordinator: any AppCoordinatorProtocol) {
        self.appCoordinator = appCoordinator
    }

    // MARK: - Public

    func pushSomeScreen() {
        appCoordinator.push(SettingsRoute.pushScreen)
    }

    func presentSomeScreen() {
        appCoordinator.presentSheet(SettingsRoute.presentScreen)
    }

    func fullScreenCover() {
        appCoordinator.presentFullScreenCover(SettingsRoute.fullScreenCover)
    }
}
