import Foundation
import AppNavigationKit

protocol TutorialScreenCoordinatorProtocol {
    
}

final class TutorialScreenCoordinator: TutorialScreenCoordinatorProtocol {

    // MARK: - Properties

    private let appCoordinator: any AppCoordinatorProtocol

    // MARK: - Init

    init(appCoordinator: any AppCoordinatorProtocol) {
        self.appCoordinator = appCoordinator
    }

    // MARK: - Public

}
