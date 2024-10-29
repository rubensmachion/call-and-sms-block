import SwiftUI
import AppNavigationKit

struct TutorialScreenView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @ObservedObject var viewModel: TutorialScreenViewModel

    init(viewModel: TutorialScreenViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
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
                Text("Tutorial settings")
            }
        }
    }
}
