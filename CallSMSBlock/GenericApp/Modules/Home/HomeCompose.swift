import Foundation

final class HomeCompose {

    static func setup(coordinator: AppCoordinator) -> HomeView {
        let homeCoordinator = HomeCoordinator(appCoordinator: coordinator)
        let viewModel = HomeViewModel(coordinator: homeCoordinator)
        let view = HomeView(viewModel: viewModel)

        return view
    }
}
