import SwiftUI

open class AppCoordinator: AppCoordinatorProtocol {
    
    // MARK: - Properties

    @Published var path: NavigationPath = .init()
    @Published var sheet: AnyScreen?
    @Published var fullScreenCover: AnyScreen?

    // MARK: - Navigation

    func push(_ screen: any AnyIdentifiable) {
        path.append(AnyScreen(screen))
    }
    
    func presentSheet(_ sheet: any AnyIdentifiable) {
        self.sheet = AnyScreen(sheet)
    }
    
    func presentFullScreenCover(_ fullScreenCover: any AnyIdentifiable) {
        self.fullScreenCover = AnyScreen(fullScreenCover)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    func dismissFullScreenOver() {
        self.fullScreenCover = nil
    }

    // MARK: - ViewBuilder

    @ViewBuilder
    func build(_ screen: AnyScreen) -> some View {
        screen.getView(self)
    }
 }
