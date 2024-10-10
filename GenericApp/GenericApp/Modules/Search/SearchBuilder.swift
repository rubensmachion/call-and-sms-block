import Foundation
import AppNavigationKit

final class SearchBuilder {

    static func setup(coordinator: AppCoordinator) -> SearchView {
        let moduleCoordinator = SearchCoordinator(appCoordinator: coordinator)
        let service = SearchService()
        let viewModel = SearchViewModel(coordinator: moduleCoordinator, service: service)
        let view = SearchView(viewModel: viewModel)

        return view
    }
}
