import Foundation
import AppNavigationKit

final class TutorialScreenBuilder {

    public enum TutorialType {
        case enableCallDirectory
    }

    static func setup(coordinator: AppCoordinator, type: TutorialType) -> TutorialScreenView {
        let moduleCoordinator = TutorialScreenCoordinator(appCoordinator: coordinator)
        let service = TutorialScreenService()
        let viewModel = TutorialScreenViewModel(coordinator: moduleCoordinator, service: service)
        let view = TutorialScreenView(viewModel: viewModel)

        return view
    }
}
