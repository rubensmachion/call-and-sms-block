import Foundation

final class SettingsBuilder {

    static func setup(coordinator: AppCoordinator) -> SettingsView {
        let moduleCoordinator = SettingsCoordinator(appCoordinator: coordinator)
        let service = SettingsService()
        let viewModel = SettingsViewModel(coordinator: moduleCoordinator, service: service)
        let view = SettingsView(viewModel: viewModel)

        return view
    }
}
