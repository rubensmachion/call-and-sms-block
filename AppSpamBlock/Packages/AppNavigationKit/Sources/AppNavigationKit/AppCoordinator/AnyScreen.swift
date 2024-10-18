import SwiftUI
import Foundation

public struct AnyScreen: AnyIdentifiable {
    private let base: any AnyIdentifiable
    private let hasher: (inout Hasher) -> Void
    private let equals: (AnyScreen) -> Bool

    public init<T: AnyIdentifiable>(_ base: T) {
        self.base = base
        self.hasher = { hasher in
            base.hash(into: &hasher)
        }
        self.equals = { other in
            guard let otherBase = other.base as? T else { return false }
            return base == otherBase
        }
    }

    public func getView(_ coordinator: AppCoordinator) -> AnyView {
        return base.getView(coordinator)
    }

    public func hash(into hasher: inout Hasher) {
        base.hash(into: &hasher)
    }

    public static func == (lhs: AnyScreen, rhs: AnyScreen) -> Bool {
        return lhs.equals(rhs)
    }
}
