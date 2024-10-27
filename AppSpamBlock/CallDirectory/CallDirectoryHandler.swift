import Foundation
import CallKit

class CallDirectoryHandler: CXCallDirectoryProvider {

    private let dataStore = DataStore()

    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self

        let dispatchGroup = DispatchGroup()
        let operationQueue = OperationQueue()

        dispatchGroup.enter()
        operationQueue.addOperation { [weak self] in
            self?.addAllBlockingPhoneNumbers(to: context) {
                dispatchGroup.leave()
            }
        }

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
            let result: [BlackListData] = try await dataStore.fetch(predicate: BlackListData.defaultPredicate())
            guard !result.isEmpty else {
                completion()
                return
            }

            for index in 0..<result.count {
                context.addBlockingEntry(withNextSequentialPhoneNumber: result[index].number)
                result[index].blocked = true
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
            guard !result.isEmpty else {
                completion()
                return
            }

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
        print(error)
    }
}
