import SwiftUI

protocol AppCoordinatorProtocol: ObservableObject {

    var path: NavigationPath { get set }
    var sheet: Sheet? { get set }
    var fullScreenCover: FullScreenCover? { get set }

    func push(_ screen:  Screen)
    func presentSheet(_ sheet: Sheet)
    func presentFullScreenCover(_ fullScreenCover: FullScreenCover)
    func pop()
    func popToRoot()
    func dismissSheet()
    func dismissFullScreenOver()
}

enum Screen: Identifiable, Hashable {
    var id: Self { return self }

    case home
    case phoneNumberDetail(phoneNumber: PhoneNumberModel?)
}

enum Sheet: Identifiable, Hashable {
    var id: Self { return self }

    case someSheet
}

enum FullScreenCover: Identifiable, Hashable {
    var id: Self { return self }

    case someScreenCover
}

extension FullScreenCover {

    func hash(into hasher: inout Hasher) {
        switch self {
        case .someScreenCover:
            return hasher.combine("someScreenCover")
        }
    }

    static func == (lhs: FullScreenCover, rhs: FullScreenCover) -> Bool {
        switch (lhs, rhs) {
        case (.someScreenCover, .someScreenCover):
            return true
        }
    }
}
