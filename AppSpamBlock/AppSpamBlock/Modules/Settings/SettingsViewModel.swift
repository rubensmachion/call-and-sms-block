import Foundation
import SwiftUI

protocol SettingsViewModelProtocol: ObservableObject {
    var menu: Dictionary<String, [SettingsViewModel.Item]> { get }
}

final class SettingsViewModel: SettingsViewModelProtocol {

    struct Item: Identifiable {
        var id: ObjectIdentifier {
            return ObjectIdentifier(Self.self)
        }

        var section: String
        var item: SettingsItems
    }

    // MARK: - Properties
    private let coordinator: SettingsCoordinatorProtocol
    private let service: SettingsServiceProcotol
    private let items: [SettingsViewModel.Item] = [
        .init(section: "Develope",
              item: .coreDataDebug)
    ]

    @Published var menu: Dictionary<String, [SettingsViewModel.Item]>

    // MARK: - Init
    init(coordinator: SettingsCoordinatorProtocol, service: SettingsServiceProcotol) {
        self.coordinator = coordinator
        self.service = service
        
        menu = Dictionary(grouping: items, by: { item in
            item.section
        })

        print(menu)
    }
}
