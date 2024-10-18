import Foundation
import AppNavigationKit

protocol Home2CoordinatorProtocol {
    func showSpamHome()
    func showSettings()
    func showCallDirectoryTutorial()
}

final class Home2Coordinator: Home2CoordinatorProtocol {

    // MARK: - Properties

    private let appCoordinator: any AppCoordinatorProtocol

    // MARK: - Init

    init(appCoordinator: any AppCoordinatorProtocol) {
        self.appCoordinator = appCoordinator
    }

    // MARK: - Public

    func showSpamHome() {
        appCoordinator.push(Home2Route.spam)
    }

    func showSettings() {
        appCoordinator.presentSheet(Home2Route.settings)
    }

    func showCallDirectoryTutorial() {
        appCoordinator.presentSheet(Home2Route.callDirectoryTutorial)
    }
}
