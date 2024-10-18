import Foundation
import AppNavigationKit

final public class SpamHomeBuilder {

    static public func setup(coordinator: AppCoordinator) -> SpamHomeView {
        let moduleCoordinator = SpamHomeCoordinator(appCoordinator: coordinator)
        let service = SpamHomeService()
        let viewModel = SpamHomeViewModel(coordinator: moduleCoordinator, service: service)
        let view = SpamHomeView(viewModel: viewModel)

        return view
    }
}
