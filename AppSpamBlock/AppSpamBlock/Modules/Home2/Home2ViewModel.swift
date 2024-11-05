import Foundation
import SwiftUI
import Combine

protocol Home2ViewModelProtocol: ObservableObject {
    func updateUI()
    func showOption(_ option: Home2Item)
    func showSettings()
    func didTapSecurityStatus()
}

final class Home2ViewModel: Home2ViewModelProtocol {

    // MARK: - Properties
    private let coordinator: Home2CoordinatorProtocol
    private let service: Home2ServiceProcotol
    private var cancellables = Set<AnyCancellable>()
    private let dataStore = DataStore()

    @Published var items = Home2Item.allCases
    @Published var securityStatus = Home2StatusView.SecurityStatus.refreshing

    // MARK: - Init
    init(coordinator: Home2CoordinatorProtocol, service: Home2ServiceProcotol) {
        self.coordinator = coordinator
        self.service = service

        updateUI()
        setupObservers()
    }

    deinit {
        cancellables.removeAll()
    }

    func updateUI() {
        switch securityStatus {
        case .enable, .disable:
            checkCallDirectoryStatus()
        default:
            break
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
        if case .disable = securityStatus {
            coordinator.showCallDirectoryTutorial()
        }
    }

    // MARK: - Private

    private func checkCallDirectoryStatus() {
        AppCallDirectoryProvider.shared.checkStatus { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .enabled:
                Task {
                    let appSystem = try await AppData.fetchData(dataStore: self.dataStore,
                                                                context: self.dataStore.backgroundContext)
                    DispatchQueue.main.async {
                        self.securityStatus = .enable(detail: appSystem?.lastUpdateQuarantine?.toFormatDate())
                    }
                }
            default:
                self.securityStatus = .disable
            }
        }
    }

    private func setupObservers() {
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                self?.updateUI()
            }.store(in: &cancellables)

        NotificationCenter.default.publisher(for: .didStartDatabaseRefreshing)
            .sink { [weak self] _ in
                self?.updateSecurityStatus(isRefreshing: true)
            }.store(in: &cancellables)

        NotificationCenter.default.publisher(for: .didStopDatabaseRefreshing)
            .sink { [weak self] _ in
                self?.updateSecurityStatus(isRefreshing: false)
            }.store(in: &cancellables)
    }

    private func updateSecurityStatus(isRefreshing: Bool) {
        guard isRefreshing else {
            checkCallDirectoryStatus()
            return
        }

        securityStatus = .refreshing
    }
}

fileprivate extension Date {
    func toFormatDate() -> String? {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        return formatter.string(from: self)
    }
}
