import SwiftUI
import AppNavigationKit

public struct SpamHomeView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @ObservedObject var viewModel: SpamHomeViewModel

    init(viewModel: SpamHomeViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        buildContent()
            .navigationTitle("Some Screen")
    }

    @ViewBuilder
    private func buildContent() -> some View {
        if viewModel.isLoading {
            ProgressView()
                .progressViewStyle(.circular)
        } else {
            VStack {
                Text("Loaded")
            }
        }
    }
}

//#Preview {
//    SpamHomeBuilder.setup(coordinator: AppCoordinator())
//}
