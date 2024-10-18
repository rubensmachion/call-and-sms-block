import Foundation
import SwiftUI
import AppNavigationKit

enum TutorialScreenRoute: AnyIdentifiable {
    case start

    func getView(_ coordinator: AppCoordinator) -> AnyView {
        switch self {
        case .start:
            AnyView(TutorialScreenBuilder.setup(coordinator: coordinator, type: .enableCallDirectory))
            
        }
    }
}
