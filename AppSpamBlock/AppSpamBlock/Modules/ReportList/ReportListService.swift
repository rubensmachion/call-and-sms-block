import Foundation

enum ReportLisResult {
    case success([IContact])
    case failure(Error)
}

enum ReportFetchType {
    case quarantine, blacklist
}

protocol ReportListServiceProcotol {
    func fetch(type: ReportFetchType, limit: Int, offset: Int, completion: @escaping (ReportLisResult) -> Void)
}

final class ReportListService: ReportListServiceProcotol {

    private let dataStore: IDataStore

    init(dataStore: IDataStore) {
        self.dataStore = dataStore
    }

    func fetch(type: ReportFetchType, limit: Int, offset: Int, completion: @escaping (ReportLisResult) -> Void) {
        Task {
            do {
                let sort = ContactQuarantineData.ascendingNumberSort()
                let response: [IContact]? = try await ContactQuarantineData.fetch(dataStore: dataStore,
                                                                                  sortDescriptors: sort,
                                                                                  predicate: nil,
                                                                                  context: dataStore.backgroundContext,
                                                                                  fetchLimit: limit,
                                                                                  offset: offset)
                guard let response = response else {
                    completion(.failure(DataStoreError.invalidData))
                    return
                }
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
