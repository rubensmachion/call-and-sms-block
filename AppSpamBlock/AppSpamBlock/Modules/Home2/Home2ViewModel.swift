import Foundation
import SwiftUI
import SpamKit

protocol Home2ViewModelProtocol: ObservableObject {
    func refresh()
    func showOption(_ option: Home2Item)
    func showSettings()
    func didTapSecurityStatus()
}

enum SecurityStatus {
    case enable, disable
}

final class Home2ViewModel: Home2ViewModelProtocol {

    // MARK: - Properties
    private let coordinator: Home2CoordinatorProtocol
    private let service: Home2ServiceProcotol
    private var isRefreshing = false

    @Published var items = Home2Item.allCases
    @Published var securityStatus = SecurityStatus.disable

    // MARK: - Init
    init(coordinator: Home2CoordinatorProtocol, service: Home2ServiceProcotol) {
        self.coordinator = coordinator
        self.service = service

        refresh()
    }

    func refresh() {
        checkCallDirectoryStatus()
        guard !isRefreshing else { return }
        isRefreshing = true
        service.fetch(lastIndex: 0, limit: 100) { [weak self] _ in
            self?.isRefreshing = false
        }
    }

    func showOption(_ option: Home2Item) {
        switch option {
        case .block:
            coordinator.showSpamHome()
        case .reportSpam:
            coordinator.showReportList()
        case .seach:
            break
        }
    }

    func showSettings() {
        coordinator.showSettings()
    }

    func didTapSecurityStatus() {
        if securityStatus == .disable {
            coordinator.showCallDirectoryTutorial()
        }
    }

    // MARK: - Private

    private func checkCallDirectoryStatus() {
        AppCallDirectoryProvider.shared.checkStatus { [weak self] status in
            switch status {
            case .enabled:
                self?.securityStatus = .enable
            default:
                self?.securityStatus = .disable
            }
        }
    }
}
