import Foundation
import AppNavigationKit
import SwiftUI

enum HomeRoute: AnyIdentifiable {
    case start
    case addNewNumber
    case editNumber(phoneNumber: BlockNumberData?)

    func getView(_ coordinator: AppCoordinator) -> AnyView {
        switch self {
        case .start:
            let view = HomeCompose.setup(coordinator: coordinator)
            return AnyView(view)

        case .addNewNumber:
            let viewModel = PhoneNumberViewModel(appCoordinator: coordinator)
            return AnyView(PhoneNumberDetailView(viewModel: viewModel))

        case .editNumber(let phoneNumber):
            return AnyView(Text("Editing"))
        }
    }
}
