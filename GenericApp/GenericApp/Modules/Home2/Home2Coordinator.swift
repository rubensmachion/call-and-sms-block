import Foundation

protocol Home2CoordinatorProtocol {
    func pushSomeScreen()
    func presentSomeScreen()
    func fullScreenCover()
}

final class Home2Coordinator: Home2CoordinatorProtocol {

    // MARK: - Properties

    private let appCoordinator: any AppCoordinatorProtocol

    // MARK: - Init

    init(appCoordinator: any AppCoordinatorProtocol) {
        self.appCoordinator = appCoordinator
    }

    // MARK: - Public

    func pushSomeScreen() {
        appCoordinator.push(Home2Route.pushScreen)
    }

    func presentSomeScreen() {
        appCoordinator.presentSheet(Home2Route.presentScreen)
    }

    func fullScreenCover() {
        appCoordinator.presentFullScreenCover(Home2Route.fullScreenCover)
    }
}
