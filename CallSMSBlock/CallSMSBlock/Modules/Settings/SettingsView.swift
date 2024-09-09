import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @ObservedObject var viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
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

#Preview {
    SettingsBuilder.setup(coordinator: AppCoordinator())
}
