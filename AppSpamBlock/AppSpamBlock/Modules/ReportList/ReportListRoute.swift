import Foundation
import SwiftUI
import AppNavigationKit

enum ReportListRoute: AnyIdentifiable {
    case start
    case pushScreen
    case presentScreen
    case fullScreenCover

    func getView(_ coordinator: AppCoordinator) -> AnyView {
        // TODO: call another module compose
        
        switch self {
        case .start:
            AnyView(ReportListBuilder.setup(coordinator: coordinator))
        case .pushScreen:
            AnyView(Text("pushScreen"))
        case .presentScreen:
            AnyView(Text("presentScreen"))
        case .fullScreenCover:
            AnyView(Text("fullScreenCover"))
        }
    }
}
