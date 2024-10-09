import SwiftUI
import Foundation

struct AnyScreen: AnyIdentifiable {
    private let base: any AnyIdentifiable
    private let hasher: (inout Hasher) -> Void
    private let equals: (AnyScreen) -> Bool

    init<T: AnyIdentifiable>(_ base: T) {
        self.base = base
        self.hasher = { hasher in
            base.hash(into: &hasher)
        }
        self.equals = { other in
            guard let otherBase = other.base as? T else { return false }
            return base == otherBase
        }
    }

    func getView(_ coordinator: AppCoordinator) -> AnyView {
        return base.getView(coordinator)
    }

    func hash(into hasher: inout Hasher) {
        base.hash(into: &hasher)
    }

    static func == (lhs: AnyScreen, rhs: AnyScreen) -> Bool {
        return lhs.equals(rhs)
    }
}
