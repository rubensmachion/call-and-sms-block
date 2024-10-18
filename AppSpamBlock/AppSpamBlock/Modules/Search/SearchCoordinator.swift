import Foundation
import AppNavigationKit

protocol SearchCoordinatorProtocol {
    func pushSomeScreen()
    func presentSomeScreen()
    func fullScreenCover()
}

final class SearchCoordinator: SearchCoordinatorProtocol {

    // MARK: - Properties

    private let appCoordinator: any AppCoordinatorProtocol

    // MARK: - Init

    init(appCoordinator: any AppCoordinatorProtocol) {
        self.appCoordinator = appCoordinator
    }

    // MARK: - Public

    func pushSomeScreen() {
        appCoordinator.push(SearchRoute.pushScreen)
    }

    func presentSomeScreen() {
        appCoordinator.presentSheet(SearchRoute.presentScreen)
    }

    func fullScreenCover() {
        appCoordinator.presentFullScreenCover(SearchRoute.fullScreenCover)
    }
}
