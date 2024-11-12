import Foundation

enum ReportLisResult {
    case success([IContact])
    case failure(Error)
}

enum ReportFetchType {
    case imported, notImported
}

protocol ReportListServiceProcotol {
    func fetch(type: ReportFetchType,
               searchTerm: String?,
               limit: Int,
               offset: Int,
               completion: @escaping (ReportLisResult) -> Void)
}

final class ReportListService: ReportListServiceProcotol {

    private let dataStore: IDataStore

    init(dataStore: IDataStore) {
        self.dataStore = dataStore
    }

    func fetch(type: ReportFetchType,
               searchTerm: String?,
               limit: Int,
               offset: Int,
               completion: @escaping (ReportLisResult) -> Void) {
        Task {
            do {
                let sort = ContactQuarantineData.ascendingNumberSort()
                var predicateFormat = ""
                var predicateArguments: [Any] = []

                if let searchTerm = searchTerm, !searchTerm.isEmpty {
                    predicateFormat = "number BEGINSWITH %@"
                    predicateArguments.append(searchTerm)
                }

                if type == .notImported {
                    if !predicateFormat.isEmpty {
                        predicateFormat.append(" AND ")
                    }
                    predicateFormat.append("processed == false")
                }

                let predicate = predicateFormat.isEmpty ? nil : NSPredicate(format: predicateFormat, argumentArray: predicateArguments)
                
                let response: [IContact]? = try await ContactQuarantineData.fetch(dataStore: dataStore,
                                                                                  sortDescriptors: sort,
                                                                                  predicate: predicate,
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
