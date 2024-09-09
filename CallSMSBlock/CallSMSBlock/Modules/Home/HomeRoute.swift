import Foundation
import SwiftUI

enum HomeRoute: AnyIdentifiable {
    case start
    case addNewNumber
    case editNumber(phoneNumber: BlockNumberData?)

    func getView(_ coordinator: AppCoordinator) -> AnyView {
        switch self {
        case .start:
            let homeCoordinator = HomeCoordinator(appCoordinator: coordinator)
            let viewModel = HomeViewModel(coordinator: homeCoordinator)
            let view = HomeView(viewModel: viewModel)

            return AnyView(view)

        case .addNewNumber:
            let viewModel = PhoneNumberViewModel(appCoordinator: coordinator)

            return AnyView(PhoneNumberDetailView(viewModel: viewModel))

        case .editNumber(let phoneNumber):
            return AnyView(Text("Editing"))
        }
    }
}
