import Foundation
import SwiftUI

protocol ReportListViewModelProtocol: ObservableObject {
    var isLoading: Bool { get }
    var isEmpty: Bool { get }
    var isFetchingMore: Bool { get }
    var pickerOptions: [String] { get }
    var searchText: String { get }
    var filteredResult: [ReportListCellItem] { get }

    func addNewReport()
    func refresh()
    func shouldLoadMoreItems(currentItem: ReportListCellItem)
}

struct ReportListCellItem: IReportListCellItem, Identifiable, Hashable, Comparable {
    var id: ObjectIdentifier {
        return ObjectIdentifier(Self.self)
    }

    var title: String
    var subtitle: String
    var isImported: Bool

    static func < (lhs: ReportListCellItem, rhs: ReportListCellItem) -> Bool {
        lhs.title == rhs.title && lhs.subtitle == rhs.subtitle && lhs.isImported == rhs.isImported
    }
}

final class ReportListViewModel: ReportListViewModelProtocol {

    enum PickerOptions: CaseIterable {
        case suspect, blocked
        var localizedTitle: String {
            switch self {
            case .suspect:
                return "Suspected SPAM"
            case .blocked:
                return "Blocked Conctacts"
            }
        }
    }

    // MARK: - Properties
    private let coordinator: ReportListCoordinatorProtocol
    private let service: ReportListServiceProcotol

    private var originalList: [IContact] = []
    private let fetchlimit: Int = 20
    private var fetchOffset: Int = .zero
    private var isFetching = false

    @Published var isLoading = false
    @Published var isEmpty = false
    @Published var isFetchingMore = false
    @Published var pickerSelection = 0 {
        didSet {
            segmentedChange()
        }
    }
    @Published var searchText: String = ""
    @Published var filteredResult: [ReportListCellItem] = []

    var pickerOptions = PickerOptions.allCases.map { $0.localizedTitle }

    // MARK: - Init
    init(coordinator: ReportListCoordinatorProtocol, service: ReportListServiceProcotol) {
        self.coordinator = coordinator
        self.service = service

        refresh()
    }

    func addNewReport() {
        refresh()
    }

    func refresh() {
        guard !isFetching else { return  }
        isLoading = originalList.isEmpty
        let fetchType = pickerSelection == .zero ? ReportFetchType.quarantine : ReportFetchType.blacklist
        service.fetch(type: fetchType, limit: fetchlimit, offset: fetchOffset) { [weak self] result in
            switch result {
            case .success(let list):
                self?.parseList(list)
            case .failure(let error):
                break
            }
        }
    }

    func shouldLoadMoreItems(currentItem: ReportListCellItem)  {
        let notLoading = !isFetching && !isLoading && !isFetchingMore
        guard currentItem == filteredResult.last, notLoading else {
            return
        }
        isFetchingMore = true
        refresh()
    }

    // MARK: - Private
    private func segmentedChange() {
        originalList.removeAll()
        filteredResult.removeAll()
        fetchOffset = .zero
        refresh()
    }

    private func parseList(_ list: [IContact]) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let parsedList: [ReportListCellItem] = list.compactMap {
                return ReportListCellItem(title: /*$0.formattedNumber ?? */String($0.number),
                                          subtitle: $0.descrip ?? "",
                                          isImported: $0.processed)
            }
            self?.fetchOffset += list.count
            self?.originalList.append(contentsOf: list)
            DispatchQueue.main.async {
                if self?.isLoading ?? false {
                    self?.isLoading = false
                }
                if self?.isFetchingMore ?? false {
                    self?.isFetchingMore = false
                }
                self?.filteredResult.append(contentsOf: parsedList)
                self?.isEmpty = self?.filteredResult.isEmpty ?? true
            }
        }
    }
}
