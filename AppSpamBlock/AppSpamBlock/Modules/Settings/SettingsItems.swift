import Foundation

enum SettingsItems {
    case coreDataDebug
}

extension SettingsItems {
    var title: String {
        switch self {
        case .coreDataDebug:
            return "CoreData Debug"
        }
    }
}
