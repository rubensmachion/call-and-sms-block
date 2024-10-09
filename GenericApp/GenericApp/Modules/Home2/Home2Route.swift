import Foundation
import SwiftUI

enum Home2Route: AnyIdentifiable {
    case start
    case pushScreen
    case presentScreen
    case fullScreenCover

    func getView(_ coordinator: AppCoordinator) -> AnyView {
        // TODO: call another module compose
        
        switch self {
        case .start:
            AnyView(Home2Builder.setup(coordinator: coordinator))
        case .pushScreen:
            AnyView(Text("pushScreen"))
        case .presentScreen:
            AnyView(Text("presentScreen"))
        case .fullScreenCover:
            AnyView(Text("fullScreenCover"))
        }
    }
}
