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
                let fetchedData = try await ContactQuarantineData.fetchPendingSyncData(dataStore: dataStore,
                                                                                       context: dataStore.backgroundContext,
                                                                                       fetchLimit: nil)
                guard let fetchedData = fetchedData, !(fetchedData.isEmpty) else {
                    return
                }
                let result = fetchedData
                for index in 0..<result.count {
                    context.addIdentificationEntry(withNextSequentialPhoneNumber: result[index].number,
                                                   label: result[index].descrip ?? "-")
                    result[index].processed = true
                }

                let appSystem = try await AppData.fetchData(dataStore: dataStore, context: dataStore.backgroundContext)
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
