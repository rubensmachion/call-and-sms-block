import CoreData
import UtilKit

protocol IContact {
    var id: Int64 { get set }
    var number: Int64 { get set }
    var date: Date { get set }
    var processed: Bool { get set }
    var descrip: String? { get set }
    var formattedNumber: String? { get set }

    static func create(dataStore: IDataStore,
                       context: NSManagedObjectContext?) throws -> IContact

    static func fetchPendingSyncData(dataStore: IDataStore,
                                     context: NSManagedObjectContext?,
                                     fetchLimit: Int?) async throws -> [IContact]?

    static func fetchLastItem(dataStore: IDataStore,
                              context: NSManagedObjectContext?) async throws -> IContact?

    static func fetch(dataStore: IDataStore,
                      sortDescriptors: [NSSortDescriptor]?,
                      predicate: NSPredicate?,
                      context: NSManagedObjectContext?,
                      fetchLimit: Int?,
                      offset: Int?) async throws -> [IContact]?
}

@objc(ContactQuarantineData)
class ContactQuarantineData: NSManagedObject, Identifiable, IContact {
    @NSManaged var id: Int64
    @NSManaged var number: Int64
    @NSManaged var date: Date
    @NSManaged var processed: Bool
    @NSManaged var descrip: String?
    @NSManaged var formattedNumber: String?

    override var description: String {
        return "id: \(id), descrip: \(descrip ?? "-"), number: \(number), date: \(date), processed: \(processed)"
    }

    convenience init(dataStore: IDataStore) {
        self.init(context: dataStore.context)
    }

    static func ascendingdateSortDescriptor() -> [NSSortDescriptor] {
        [NSSortDescriptor(key: "id", ascending: true)]
    }

    static func descendingdateSortDescriptor() -> [NSSortDescriptor] {
        [NSSortDescriptor(key: "id", ascending: false)]
    }

    static func ascendingNumberSort() -> [NSSortDescriptor] {
        [NSSortDescriptor(key: "number", ascending: true)]
    }

    static func quarantineUnprocessedListPredicate() -> NSPredicate {
        NSPredicate(format: "processed == false")
    }

    static func create(dataStore: IDataStore,
                       context: NSManagedObjectContext?) throws -> IContact {
        let _context = context ?? dataStore.context
        let result: ContactQuarantineData = try dataStore.create(context: _context)
        return result
    }

    static func fetchPendingSyncData(dataStore: IDataStore,
                                     context: NSManagedObjectContext?,
                                     fetchLimit: Int?) async throws -> [IContact]? {

        let sort = ContactQuarantineData.ascendingNumberSort()
        let predicate = ContactQuarantineData.quarantineUnprocessedListPredicate()
        let fetchLimit = fetchLimit ?? 500
        let result: [IContact]? = try await fetch(dataStore: dataStore,
                                                  sortDescriptors: sort,
                                                  predicate: predicate,
                                                  context: context,
                                                  fetchLimit: fetchLimit,
                                                  offset: nil)
        return result
    }

    static func fetchLastItem(dataStore: IDataStore,
                              context: NSManagedObjectContext?) async throws -> IContact? {

        let sort = ContactQuarantineData.descendingdateSortDescriptor()
        let fetchLimit = 1
        let result: [IContact]? = try await fetch(dataStore: dataStore,
                                                  sortDescriptors: sort,
                                                  predicate: nil,
                                                  context: context,
                                                  fetchLimit: fetchLimit,
                                                  offset: nil)

        return result?.last
    }

    static func fetch(dataStore: IDataStore,
                      sortDescriptors: [NSSortDescriptor]?,
                      predicate: NSPredicate?,
                      context: NSManagedObjectContext?,
                      fetchLimit: Int?,
                      offset: Int?) async throws -> [IContact]? {
        var result: [ContactQuarantineData]?

        guard let context = context else {
            result = try await dataStore.fetch(sortDescriptors: sortDescriptors,
                                               predicate: predicate,
                                               context: dataStore.context,
                                               fetchLimit: fetchLimit,
                                               offset: offset)
            return result
        }

        result = try await dataStore.fetch(sortDescriptors: sortDescriptors,
                                           predicate: predicate,
                                           context: context,
                                           fetchLimit: fetchLimit,
                                           offset: offset)
        return result
    }
}
