import SwiftUI

open class AppCoordinator: AppCoordinatorProtocol {

    @Published var path: NavigationPath = .init()
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?

    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func presentSheet(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func presentFullScreenCover(_ fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
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

    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case .home:
            HomeView(appCoordinator: self)
        case .phoneNumberDetail(let phoneNumber):
            PhoneNumberDetailView(appCoordinator: self)
        }
    }

    @ViewBuilder
    func build(_ sheet: Sheet) -> some View {
        switch sheet {
        case .someSheet:
            Text("someSheet")
        }
    }

    @ViewBuilder
    func build(_ fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .someScreenCover:
            Text("someScreenCover")
        }
    }
 }
