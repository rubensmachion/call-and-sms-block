import Foundation
import AppNavigationKit

final class ReportListBuilder {

    static func setup(coordinator: AppCoordinator) -> ReportListView {
        let moduleCoordinator = ReportListCoordinator(appCoordinator: coordinator)
        let service = ReportListService()
        let viewModel = ReportListViewModel(coordinator: moduleCoordinator, service: service)
        let view = ReportListView(viewModel: viewModel)

        return view
    }
}
