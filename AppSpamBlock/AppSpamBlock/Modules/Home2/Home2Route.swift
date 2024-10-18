import Foundation
import SwiftUI
import AppNavigationKit
import SpamKit

enum Home2Route: AnyIdentifiable {
    case start
    case spam
    case settings

    func getView(_ coordinator: AppCoordinator) -> AnyView {        
        switch self {
        case .start:
            AnyView(Home2Builder.setup(coordinator: coordinator))
        case .spam:
            AnyView(SpamHomeBuilder.setup(coordinator: coordinator))
        case .settings:
            AnyView(SettingsBuilder.setup(coordinator: coordinator))
        }
    }
}
