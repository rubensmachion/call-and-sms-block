import SwiftUI
import AppNavigationKit

struct ReportListView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @ObservedObject var viewModel: ReportListViewModel

    @State var pickerChoosed = 0

    init(viewModel: ReportListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        buildContent()
            .navigationTitle("Reports")
            .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func buildContent() -> some View {
        VStack {
            buildList()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                buildPicker()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.addNewReport()
                }, label: {
                    Image(systemName: "plus")
                })
            }
        }
    }

    @ViewBuilder
    private func buildPicker() -> some View {
        let options = viewModel.pickerOptions
        let count = options.count
        Picker(selection: $viewModel.pickerSelection) {
            ForEach(0..<count, id: \.self) { index in
                Text(options[index]).tag(index)
            }
        } label: {
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }

    @ViewBuilder
    private func buildList() -> some View {
        VStack {
            if viewModel.isEmpty {
                EmptyStateView(title: "No content")
            } else {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    List {
                        ForEach($viewModel.filteredResult, id: \.self) { item in
                            let cellItem = ReportListCellItem(title: item.title.wrappedValue,
                                                              subtitle: item.subtitle.wrappedValue, 
                                                              isImported: item.isImported.wrappedValue)
                            ReportListCell(item: cellItem)
                                .onAppear {
                                    viewModel.shouldLoadMoreItems(currentItem: item.wrappedValue)
                                }
                        }

                        if viewModel.isFetchingMore {
                            HStack {
                                VStack(alignment: .center) {
                                    Text("Loading")
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .searchable(text: $viewModel.searchText)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        ReportListBuilder.setup(coordinator: AppCoordinator.appCoodinator())
    }
}
