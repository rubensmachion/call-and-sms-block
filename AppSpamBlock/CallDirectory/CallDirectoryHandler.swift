import Foundation
import CallKit

class CallDirectoryHandler: CXCallDirectoryProvider {

    private let dataStore = DataStore()

    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self

//        addAllBlockingPhoneNumbers(to: context) {
//            context.completeRequest()
//        }
        addIdenfityPhoneNumbers(to: context) {
            context.completeRequest()
        }
    }

    private func addAllBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext, 
                                            completion: @escaping () -> Void) {
        Task {
            let result: [BlockNumberData] = try await dataStore.fetch(predicate: BlockNumberData.defaultPredicate())
            guard !result.isEmpty else {
                completion()
                return
            }

            for index in 0..<result.count {
                context.addBlockingEntry(withNextSequentialPhoneNumber: result[index].number)
                result[index].isBlocked.toggle()
            }
            do {
                try dataStore.save()
            } catch {
                print("Failed save \(error)")
            }
            completion()
        }
    }

    private func addIdenfityPhoneNumbers(to context: CXCallDirectoryExtensionContext,
                                         completion: @escaping () -> Void) {
        Task {
            let result: [QuarantineData] = try await dataStore.fetch(predicate: QuarantineData.defaultPredicate())
            for index in 0..<result.count {
                context.addIdentificationEntry(withNextSequentialPhoneNumber: result[index].number,
                                               label: result[index].descrip ?? "-")
                result[index].imported = true
            }
            
            do {
                try dataStore.save()
            } catch {
                print("Failed save \(error)")
            }
            completion()
        }
    }
}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {

    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        // An error occurred while adding blocking or identification entries, check the NSError for details.
        // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
        //
        // This may be used to store the error details in a location accessible by the extension's containing app, so that the
        // app may be notified about errors which occurred while loading data even if the request to load data was initiated by
        // the user in Settings instead of via the app itself.
        print(error)
    }

}
