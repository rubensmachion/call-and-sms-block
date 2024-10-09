import Foundation
import SwiftUI

protocol Home2ViewModelProtocol: ObservableObject {
    var isLoading: Bool { get }
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
            self.isLoading = false
        }
    }
}
