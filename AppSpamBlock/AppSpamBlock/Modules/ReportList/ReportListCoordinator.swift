import Foundation
import AppNavigationKit

protocol ReportListCoordinatorProtocol {
    func pushSomeScreen()
    func presentSomeScreen()
    func fullScreenCover()
}

final class ReportListCoordinator: ReportListCoordinatorProtocol {

    // MARK: - Properties

    private let appCoordinator: any AppCoordinatorProtocol

    // MARK: - Init

    init(appCoordinator: any AppCoordinatorProtocol) {
        self.appCoordinator = appCoordinator
    }

    // MARK: - Public

    func pushSomeScreen() {
        appCoordinator.push(ReportListRoute.pushScreen)
    }

    func presentSomeScreen() {
        appCoordinator.presentSheet(ReportListRoute.presentScreen)
    }

    func fullScreenCover() {
        appCoordinator.presentFullScreenCover(ReportListRoute.fullScreenCover)
    }
}
