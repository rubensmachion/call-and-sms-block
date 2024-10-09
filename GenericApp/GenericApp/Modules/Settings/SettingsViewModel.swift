import Foundation
import SwiftUI

protocol SettingsViewModelProtocol: ObservableObject {
    var isLoading: Bool { get }
}

final class SettingsViewModel: SettingsViewModelProtocol {

    // MARK: - Properties
    private let coordinator: SettingsCoordinatorProtocol
    private let service: SettingsServiceProcotol

    @Published var isLoading = false

    // MARK: - Init
    init(coordinator: SettingsCoordinatorProtocol, service: SettingsServiceProcotol) {
        self.coordinator = coordinator
        self.service = service
        isLoading = true

        service.fetch { _ in
            self.isLoading = false
        }
    }
}
