import SwiftUI
import AppNavigationKit

struct Home2View: View {

    // MARK: - Properties
    
    @EnvironmentObject var appCoordinator: AppCoordinator
    @ObservedObject var viewModel: Home2ViewModel

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    // MARK: - Init

    init(viewModel: Home2ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        buildContent()
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.showSettings()
                    }, label: {
                        Image(systemName: "gear")
                    })
                }
            }
    }

    @ViewBuilder
    private func buildContent() -> some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                buildCollectionView()
            }
        }
    }

    @ViewBuilder
    private func buildCollectionView() -> some View {
        ScrollView {
            LazyVGrid(columns: columns,
                      content: {
                ForEach($viewModel.items) { item in
                    Home2CellView(item: item.wrappedValue)
                        .onTapGesture {
                            viewModel.showOption(item.wrappedValue)
                        }
                }
            })
            .padding()
        }
    }
}
