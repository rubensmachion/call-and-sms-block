import Foundation

final class Home2Builder {

    static func setup(coordinator: AppCoordinator) -> Home2View {
        let moduleCoordinator = Home2Coordinator(appCoordinator: coordinator)
        let service = Home2Service()
        let viewModel = Home2ViewModel(coordinator: moduleCoordinator, service: service)
        let view = Home2View(viewModel: viewModel)

        return view
    }
}
