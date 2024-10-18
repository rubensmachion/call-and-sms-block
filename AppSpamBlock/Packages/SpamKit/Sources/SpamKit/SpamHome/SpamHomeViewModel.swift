import Foundation
import SwiftUI

protocol SpamHomeViewModelProtocol: ObservableObject {
    var isLoading: Bool { get }
}

final class SpamHomeViewModel: SpamHomeViewModelProtocol {

    // MARK: - Properties
    private let coordinator: SpamHomeCoordinatorProtocol
    private let service: SpamHomeServiceProcotol

    @Published var isLoading = false

    // MARK: - Init
    init(coordinator: SpamHomeCoordinatorProtocol, service: SpamHomeServiceProcotol) {
        self.coordinator = coordinator
        self.service = service
        isLoading = true

        service.fetch { _ in
            self.isLoading = false
        }
    }
}
