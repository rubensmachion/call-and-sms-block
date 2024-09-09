import SwiftUI

struct AppCoordinatorView: View {
    @StateObject var appCoordinator = AppCoordinator()

    var body: some View {
        NavigationStack(path: $appCoordinator.path) {
            appCoordinator.build(AnyScreen(HomeRoute.start))
                .navigationDestination(for: AnyScreen.self) { screen in
                    appCoordinator.build(screen)
                }
                .sheet(item: $appCoordinator.sheet) { sheet in
                    appCoordinator.build(sheet)
                }
                .fullScreenCover(item: $appCoordinator.fullScreenCover) { fullScreenCover in
                    appCoordinator.build(fullScreenCover)
                }
        }
        .environmentObject(appCoordinator)
    }
}

#Preview {
    AppCoordinatorView()
}
