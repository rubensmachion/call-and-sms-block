import Foundation

enum ReportLisResult {
    case success([ContactQuarantineData])
    case failure(Error)
}

enum ReportFetchType {
    case quarantine, blacklist
}

protocol ReportListServiceProcotol {
    func fetch(type: ReportFetchType, limit: Int, offset: Int, completion: @escaping (ReportLisResult) -> Void)
}

final class ReportListService: ReportListServiceProcotol {

    private let dataStore = DataStore()

    func fetch(type: ReportFetchType, limit: Int, offset: Int, completion: @escaping (ReportLisResult) -> Void) {
        Task {
            do {
                let predicate = type == .quarantine ? ContactQuarantineData.quarantineListPredicate() : ContactQuarantineData.blackListPredicate()
                let response: [ContactQuarantineData] = try await dataStore.fetch(sortDescriptors: ContactQuarantineData.ascendingdateSortDescriptor(),
                                                                                  predicate: predicate,
                                                                                  context: dataStore.backgroundContext,
                                                                                  fetchLimit: limit,
                                                                                  offset: offset)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
