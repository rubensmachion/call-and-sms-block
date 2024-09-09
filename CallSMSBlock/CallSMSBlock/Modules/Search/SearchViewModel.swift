import Foundation
import SwiftUI

protocol SearchViewModelProtocol: ObservableObject {
    var isLoading: Bool { get }
}

final class SearchViewModel: SearchViewModelProtocol {

    // MARK: - Properties
    private let coordinator: SearchCoordinatorProtocol
    private let service: SearchServiceProcotol

    @Published var isLoading = false

    // MARK: - Init
    init(coordinator: SearchCoordinatorProtocol, service: SearchServiceProcotol) {
        self.coordinator = coordinator
        self.service = service
        isLoading = true

        service.fetch { _ in
            self.isLoading = false
        }
    }
}
