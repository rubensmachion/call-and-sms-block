import SwiftUI
import Foundation

protocol HomeCoordinatorProtocol {
    func showAddSpam()
    func showEdit(data: BlockNumberData)
}

class HomeCoordinator: HomeCoordinatorProtocol {

    private let appCoordinator: any AppCoordinatorProtocol

    init(appCoordinator: any AppCoordinatorProtocol) {
        self.appCoordinator = appCoordinator
    }

    func showAddSpam() {
        appCoordinator.push(HomeRoute.addNewNumber)
    }

    func showEdit(data: BlockNumberData) {
        appCoordinator.presentSheet(HomeRoute.editNumber(phoneNumber: data))
    }
}
