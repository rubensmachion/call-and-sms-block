import Foundation
import SwiftUI
import SpamKit

protocol Home2ViewModelProtocol: ObservableObject {
    var isLoading: Bool { get }

    func showOption(_ option: Home2Item)
    func showSettings()
}

final class Home2ViewModel: Home2ViewModelProtocol {

    // MARK: - Properties
    private let coordinator: Home2CoordinatorProtocol
    private let service: Home2ServiceProcotol

    @Published var isLoading = false
    @Published var items = Home2Item.allCases

    // MARK: - Init
    init(coordinator: Home2CoordinatorProtocol, service: Home2ServiceProcotol) {
        self.coordinator = coordinator
        self.service = service
        isLoading = true

        service.fetch { _ in
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
            }
        }
    }

    func showOption(_ option: Home2Item) {
        switch option {
        case .block:
            coordinator.showSpamHome()
        case .reportSpam:
            break
        case .seach:
            break
        }
    }

    func showSettings() {
        coordinator.showSettings()
    }

    private func checkCallDirectoryStatus() {
        AppCallDirectoryProvider.shared.checkStatus { status in

        }
    }
}
