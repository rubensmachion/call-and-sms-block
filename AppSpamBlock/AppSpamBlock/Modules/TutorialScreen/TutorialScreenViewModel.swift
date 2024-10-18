import Foundation
import SwiftUI

protocol TutorialScreenViewModelProtocol: ObservableObject {
    var isLoading: Bool { get }
}

final class TutorialScreenViewModel: TutorialScreenViewModelProtocol {

    // MARK: - Properties
    
    private let coordinator: TutorialScreenCoordinatorProtocol
    private let service: TutorialScreenServiceProcotol

    @Published var isLoading = false

    // MARK: - Init
    init(coordinator: TutorialScreenCoordinatorProtocol, service: TutorialScreenServiceProcotol) {
        self.coordinator = coordinator
        self.service = service
        isLoading = true

        service.fetch { _ in
            self.isLoading = false
        }
    }
}
