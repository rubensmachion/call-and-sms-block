import SwiftUI
import Foundation

public protocol AnyIdentifiable: Identifiable, Hashable {
    func getView(_ coordinator: AppCoordinator) -> AnyView
}

public extension AnyIdentifiable {
    var id: ObjectIdentifier {
        return ObjectIdentifier(Self.self)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
