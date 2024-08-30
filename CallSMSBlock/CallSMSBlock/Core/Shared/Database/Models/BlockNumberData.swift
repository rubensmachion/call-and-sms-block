import Foundation
import CoreData

class BlockNumberData: NSManagedObject, ManagedDataProtocol, Identifiable {

    @NSManaged var id: String
    @NSManaged var name: String?
    @NSManaged var number: Int64
    @NSManaged var isBlocked: Bool
    @NSManaged var shouldUnlock: Bool
    @NSManaged var date: Date

    convenience init(dataStore: DataStore) {
        self.init(context: dataStore.persistentContainer.viewContext)
    }

    static func ascendingdateSortDescriptor() -> [NSSortDescriptor] {
        [NSSortDescriptor(key: "date", ascending: true)]
    }

    static func defaultPredicate() -> NSPredicate {
        NSPredicate(format: "isBlocked == false")
    }
}
