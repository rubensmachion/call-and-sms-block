import Foundation
import AppNavigationKit

protocol SpamHomeCoordinatorProtocol {
    func pushSomeScreen()
    func presentSomeScreen()
    func fullScreenCover()
}

final class SpamHomeCoordinator: SpamHomeCoordinatorProtocol {

    // MARK: - Properties

    private let appCoordinator: any AppCoordinatorProtocol

    // MARK: - Init

    init(appCoordinator: any AppCoordinatorProtocol) {
        self.appCoordinator = appCoordinator
    }

    // MARK: - Public

    func pushSomeScreen() {
        appCoordinator.push(SpamHomeRoute.pushScreen)
    }

    func presentSomeScreen() {
        appCoordinator.presentSheet(SpamHomeRoute.presentScreen)
    }

    func fullScreenCover() {
        appCoordinator.presentFullScreenCover(SpamHomeRoute.fullScreenCover)
    }
}
