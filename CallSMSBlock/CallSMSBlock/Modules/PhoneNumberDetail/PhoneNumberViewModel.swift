import Foundation
import SwiftUI
import PhoneNumberKit

protocol PhoneNumberViewModelProtocol: ObservableObject {

    func save(name: String?, ddi: String, fromNumber: String, toNumber: String?) -> Bool
    func back()
    func formatNumber(_ number: String, ddi: String) -> String?
}

final class PhoneNumberViewModel: PhoneNumberViewModelProtocol {
    // MARK: - Properties
    private let appCoordinator: AppCoordinator
    private let phoneNumberUtility = PhoneNumberUtility()
    private let dataStore = DataStore()

    @Published var messageError: String?
    @Published var isPresent = false

    // MARK: - Init
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func save(name: String?, ddi: String, fromNumber: String, toNumber: String?) -> Bool {
        guard let from = isValidEntry(ddi: ddi, number: fromNumber) else {
            return false
        }
        var isSuccess = false
        if let toNumber = toNumber, !toNumber.isEmpty {
            guard let to = isValidEntry(ddi: ddi, number: toNumber) else {
                return false
            }

            let range = from...to
            Task {
                _ = await saveRangeNumber(name: name, range: range)
                AppCallDirectoryProvider.shared.reloadCallDirectory()
            }
            isSuccess = true
        } else {
            isSuccess = saveSingleNumber(name: name, number: from)
        }

        return isSuccess
    }

    func back() {
        appCoordinator.pop()
    }

    func formatNumber(_ number: String, ddi: String) -> String? {
        do {
            guard let country = phoneNumberUtility.countries(withCode: UInt64(ddi) ?? 55)?.first else {
                return nil
            }
            let phone = try phoneNumberUtility.parse("\(number)", withRegion: country)
            return phoneNumberUtility.format(phone, toType: .national)
        } catch {
            print(error)
        }
        return nil
    }

    // MARK: - Private
    private func saveRangeNumber(name: String?, range: ClosedRange<Int>) async -> Bool {
        _ = range.map { number in
            let data = BlockNumberData(context: dataStore.persistentContainer.viewContext)
            data.id = UUID().uuidString
            data.name = name
            data.number = Int64(number)
            data.isBlocked = false
            data.shouldUnlock = false
            return data
        }
        do {
            try dataStore.save()
            return true
        } catch {
            return false
        }
    }

    private func saveSingleNumber(name: String?, number: Int) -> Bool {
        do {
            let data = BlockNumberData(context: dataStore.persistentContainer.viewContext)
            data.id = UUID().uuidString
            data.name = name
            data.number = Int64(number)
            data.isBlocked = false
            data.shouldUnlock = false

            try dataStore.save()
            AppCallDirectoryProvider.shared.reloadCallDirectory()
            return true
        } catch {
            // TODO: Handle error
            print(error)
        }

        return false
    }

    private func isValidEntry(ddi: String, number: String) -> Int? {
        guard !ddi.isEmpty, ddi.toInt() != nil else {
            messageError = "invalid DDI"
            return nil
        }

        guard !number.isEmpty, number.toInt() != nil else {
            messageError = "invalid number"
            return nil
        }

        guard let number = "\(ddi)\(number)".toInt() else {
            messageError = "invalid number"
            return nil
        }

        return number
    }
}
