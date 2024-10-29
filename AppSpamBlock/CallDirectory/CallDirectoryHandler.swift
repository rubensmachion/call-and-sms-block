import Foundation
import CallKit

class CallDirectoryHandler: CXCallDirectoryProvider {

    private let dataStore = DataStore()

    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self

        let dispatchGroup = DispatchGroup()
        let operationQueue = OperationQueue()

//        dispatchGroup.enter()
//        operationQueue.addOperation { [weak self] in
//            self?.addAllBlockingPhoneNumbers(to: context) {
//                dispatchGroup.leave()
//            }
//        }

        dispatchGroup.enter()
        operationQueue.addOperation { [weak self] in
            self?.addIdenfityPhoneNumbers(to: context) {
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            context.completeRequest()
        }
    }

    private func addAllBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext, 
                                            completion: @escaping () -> Void) {
        Task {
            let result: [ContactQuarantineData] = try await dataStore.fetch(predicate: ContactQuarantineData.blackUnimportedListPredicate(),
                                                                    context: dataStore.backgroundContext)
            guard !result.isEmpty else {
                completion()
                return
            }

            for index in 0..<result.count {
                context.addBlockingEntry(withNextSequentialPhoneNumber: result[index].number)
                result[index].blocked = true
            }

            do {
                try dataStore.save(context: dataStore.backgroundContext)
            } catch {
                print("Failed save \(error)")
            }
            completion()
        }
    }

    private func addIdenfityPhoneNumbers(to context: CXCallDirectoryExtensionContext,
                                         completion: @escaping () -> Void) {
        Task { // 55 11 98115 9541
            let result: [ContactQuarantineData] = try await dataStore.fetch(predicate: ContactQuarantineData.quarantineUnimportedListPredicate(),
                                                                            context: dataStore.backgroundContext,
                                                                            fetchLimit: 1)

            guard !result.isEmpty else {
                completion()
                return
            }

            print("######################################")
            for index in 0..<result.count {
                print("add: \(result[index].number)")
                context.addIdentificationEntry(withNextSequentialPhoneNumber: result[index].number,
                                               label: result[index].descrip ?? "-")
                result[index].imported = true
            }
            print("######################################")

            do {
                try dataStore.save(context: dataStore.backgroundContext)
            } catch {
                print("Failed save \(error)")
            }
            completion()
        }
    }
}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {

    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        print(error)
    }
}
