import SwiftUI
import AppNavigationKit

struct SettingsView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @ObservedObject var viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        buildContent()
            .navigationTitle("Settings")
    }

    @ViewBuilder
    private func buildContent() -> some View {
        List {
            ForEach(viewModel.menu.keys.sorted(), id: \.self) { cat in
                Section(header: Text(cat)) {
                    ForEach(viewModel.menu[cat] ?? []) { item in
                        Text(item.item.title)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}
