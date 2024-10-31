import Foundation
import CallKit

class CallDirectoryHandler: CXCallDirectoryProvider {

    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self

        addIdentification(context: context) {
            print("CallDirectoryHandler finished reloading")
            context.completeRequest()
        }
    }

    private func addIdentification(context: CXCallDirectoryExtensionContext, completion: @escaping () -> Void) {
        Task {
            do {
                let dataStore = DataStore()

                let result: [ContactQuarantineData] = try await dataStore.fetch(sortDescriptors: ContactQuarantineData.ascendingNumberSort(),
                                                                                predicate: ContactQuarantineData.quarantineUnimportedListPredicate(),
                                                                                context: dataStore.backgroundContext,
                                                                                fetchLimit: 500)
                guard !result.isEmpty else {
                    return
                }
                for index in 0..<result.count {
                    context.addIdentificationEntry(withNextSequentialPhoneNumber: result[index].number,
                                                   label: result[index].descrip ?? "-")
                    result[index].blocked = true
                }

                let appSystem: AppData? = try await dataStore.fetchSingle(context: dataStore.backgroundContext)
                appSystem?.lastUpdateQuarantine = Date()
                try dataStore.save(context: dataStore.backgroundContext)

                print("Saved: \(result.count) registers")
            } catch {
                print("Failed save \(error)")
            }
            completion()
        }
    }
}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {

    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        print(error.localizedDescription)
    }
}
