import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    @State var searchText: String = ""

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            listView()
        }
        .navigationTitle("Blocked numbers")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add") {
                    viewModel.showNewPhoneNumber()
                }
            }
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) { newValue in
            viewModel.reloadData(filter: newValue)
        }
        .onAppear(perform: {
            viewModel.reloadData(filter: nil)
        })
    }

    @ViewBuilder
    private func listView() -> some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else if viewModel.searchResults.isEmpty {
                EmptyStateView(title: "No blocked")
            } else {

                List(viewModel.searchResults) { item in
                    HomeViewCell(item: item)
                }
                .listStyle(.plain)
            }
        }
    }
}

//#Preview {
//    HomeView(viewModel: .init(appCoordinator: .init()))
//}
