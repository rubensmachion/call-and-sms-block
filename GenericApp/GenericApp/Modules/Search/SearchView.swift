import SwiftUI

struct SearchView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @ObservedObject var viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
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
                Text("Loaded")
            }
        }
    }
}

//#Preview {
//    SearchBuilder.setup(coordinator: AppCoordinator())
//}
