import CoreData

class AppData: NSManagedObject, ManagedDataProtocol, Identifiable {
    @NSManaged var id: Int64
    @NSManaged var lastUpdateQuarantine: Date?

    static func ascendingdateSortDescriptor() -> [NSSortDescriptor] {
        [NSSortDescriptor(key: "id", ascending: true)]
    }
}
