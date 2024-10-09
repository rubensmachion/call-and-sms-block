import SwiftUI

protocol AppCoordinatorProtocol: ObservableObject {
    var path: NavigationPath { get set }
    var sheet: (AnyScreen)? { get set }
    var fullScreenCover: AnyScreen? { get set }

    func push(_ screen: any AnyIdentifiable)
    func presentSheet(_ sheet: (any AnyIdentifiable))
    func presentFullScreenCover(_ fullScreenCover: any AnyIdentifiable)
    func pop()
    func popToRoot()
    func dismissSheet()
    func dismissFullScreenOver()
}
