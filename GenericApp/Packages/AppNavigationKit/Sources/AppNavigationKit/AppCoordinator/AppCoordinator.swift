import SwiftUI

open class AppCoordinator: AppCoordinatorProtocol {
    
    // MARK: - Properties

    @Published public var path: NavigationPath = .init()
    @Published public var sheet: AnyScreen?
    @Published public var fullScreenCover: AnyScreen?

    // MARK: - Navigation

    public func push(_ screen: any AnyIdentifiable) {
        path.append(AnyScreen(screen))
    }
    
    public func presentSheet(_ sheet: any AnyIdentifiable) {
        self.sheet = AnyScreen(sheet)
    }
    
    public func presentFullScreenCover(_ fullScreenCover: any AnyIdentifiable) {
        self.fullScreenCover = AnyScreen(fullScreenCover)
    }
    
    public func pop() {
        path.removeLast()
    }
    
    public func popToRoot() {
        path.removeLast(path.count)
    }
    
    public func dismissSheet() {
        self.sheet = nil
    }
    
    public func dismissFullScreenOver() {
        self.fullScreenCover = nil
    }

    // MARK: - ViewBuilder

    @ViewBuilder
    public func build(_ screen: AnyScreen) -> some View {
        screen.getView(self)
    }
 }
