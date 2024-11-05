import CoreData

protocol IAppData: ManagedDataProtocol {
    var id: Int64 { get set }
    var lastUpdateQuarantine: Date? { get set }
}

class AppData: NSManagedObject, Identifiable {
    @NSManaged var id: Int64
    @NSManaged var lastUpdateQuarantine: Date?

    static func ascendingdateSortDescriptor() -> [NSSortDescriptor] {
        [NSSortDescriptor(key: "id", ascending: true)]
    }

    static func fetchData(dataStore: IDataStore, context: NSManagedObjectContext? = nil) async throws -> AppData? {
        guard let context = context else {
            return try await dataStore.fetchSingle(context: dataStore.context)
        }

        return try await dataStore.fetchSingle(context: context)
    }
}
