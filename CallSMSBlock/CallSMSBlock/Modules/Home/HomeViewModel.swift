import Foundation
import SwiftUI
import CoreData

protocol HomeViewModelProtocol: ObservableObject {
    var isLoading: Bool { get }
    var searchResults: [BlockNumberData] { get }
    var listaData: [BlockNumberData] { get }

    func reloadData(filter text: String?)

    func showNewPhoneNumber()
    func showEditPhoneNumber()
}

final class HomeViewModel: HomeViewModelProtocol {

    // MARK: - Properties
    private let appCoordinator: AppCoordinator
    private let dataStore = DataStore()

    @Published var isLoading = false
    @Published var searchResults: [BlockNumberData] = []

    var listaData: [BlockNumberData] = []

    // MARK: - Init
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator

        reloadData(filter: nil)
    }

    func reloadData(filter text: String?) {
        isLoading = true
        Task {
            do {
                let result: [BlockNumberData]? = try await dataStore.fetch(sortDescriptors: BlockNumberData.ascendingdateSortDescriptor())
                listaData = result?.filter {
                    !$0.shouldUnlock
                }/*.compactMap {
                    .init(id: $0.id ?? "",
                          number: $0.number,
                          name: $0.name,
                          formattedNumber: $0.number.toFormattedPhoneNumber() ?? "-")
                }*/ ?? []
                await MainActor.run {
                    self.filter(text: text ?? "")
                    self.isLoading = false
                }
            } catch {
                print(error)
            }
        }
    }

    func showNewPhoneNumber() {
        appCoordinator.push(.phoneNumberDetail(phoneNumber: nil))
    }

    func showEditPhoneNumber() {
        // TODO: Handle edit information
//        appCoordinator.push(.phoneNumberDetail(phoneNumber: PhoneNumberModel(id: "teste", name: "Teste")))
    }

    // MARK: - Private
    private func filter(text: String) {
        if text.isEmpty {
            searchResults = listaData
        } else {
            searchResults = listaData.filter {
                $0.number.toFormattedPhoneNumber()?.lowercased().contains(text.lowercased()) ?? false
            }
        }
    }
}
