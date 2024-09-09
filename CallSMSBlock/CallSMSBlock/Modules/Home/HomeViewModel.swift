import Foundation
import SwiftUI
import CoreData

protocol HomeViewModelProtocol: ObservableObject {
    var isLoading: Bool { get }
    var searchResults: [BlockNumberGroup] { get }
    var listaData: [BlockNumberGroup] { get }

    func reloadData(filter text: String?)

    func showNewPhoneNumber()
    func showEditPhoneNumber()
}

final class HomeViewModel: HomeViewModelProtocol {

    // MARK: - Properties
    private let coordinator: HomeCoordinatorProtocol
    private let dataStore = DataStore()

    @Published var isLoading = false
    @Published var searchResults: [BlockNumberGroup] = []

    var listaData: [BlockNumberGroup] = []

    // MARK: - Init
    init(coordinator: HomeCoordinatorProtocol) {
        self.coordinator = coordinator

        reloadData(filter: nil)
    }

    func reloadData(filter text: String?) {
        isLoading = true
        Task {
            do {
                let result: [BlockNumberGroup]? = try await dataStore.fetch(sortDescriptors: BlockNumberGroup.ascendingdateSortDescriptor())
                listaData = result ?? []
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
        coordinator.showAddSpam()
    }

    func showEditPhoneNumber() {
        // TODO: Handle edit information
//        coordinator.showEdit(data: .)
//        appCoordinator.push(.phoneNumberDetail(phoneNumber: PhoneNumberModel(id: "teste", name: "Teste")))
    }

    // MARK: - Private
    private func filter(text: String) {
        if text.isEmpty {
            searchResults = listaData
        } else {
//            searchResults = listaData.filter {
//                $0.number.toFormattedPhoneNumber()?.lowercased().contains(text.lowercased()) ?? false
//            }
        }
    }
}
