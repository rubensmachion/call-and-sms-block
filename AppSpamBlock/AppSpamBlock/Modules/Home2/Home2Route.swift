import Foundation
import SwiftUI
import AppNavigationKit

enum Home2Route: AnyIdentifiable {
    case start
    case spam
    case settings
    case callDirectoryTutorial
    case reportList

    func getView(_ coordinator: AppCoordinator) -> AnyView {
        switch self {
        case .start:
            AnyView(Home2Builder.setup(coordinator: coordinator))
        case .spam:
            AnyView(Text("Spam"))
//            AnyView(SpamHomeBuilder.setup(coordinator: coordinator))
        case .settings:
            AnyView(SettingsBuilder.setup(coordinator: coordinator))
        case .callDirectoryTutorial:
            AnyView(TutorialScreenBuilder.setup(coordinator: coordinator, type: .enableCallDirectory))
        case .reportList:
            AnyView(ReportListBuilder.setup(coordinator: coordinator))
        }
    }
}
