import CoreData

class QuarantineData: NSManagedObject, ManagedDataProtocol, Identifiable {

    @NSManaged var id: Int64
    @NSManaged var descrip: String?
    @NSManaged var number: Int64
    @NSManaged var date: Date
    @NSManaged var imported: Bool

    convenience init(dataStore: DataStore) {
        self.init(context: dataStore.persistentContainer.viewContext)
    }

    static func defaultPredicate() -> NSPredicate {
        NSPredicate(format: "imported == false")
    }

    static func ascendingdateSortDescriptor() -> [NSSortDescriptor] {
        [NSSortDescriptor(key: "id", ascending: true)]
    }
}
