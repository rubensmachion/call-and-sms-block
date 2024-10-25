import CoreData

class BlackListData: NSManagedObject, ManagedDataProtocol, Identifiable {

    @NSManaged var id: Int64
    @NSManaged var number: Int64
    @NSManaged var date: Date

    convenience init(dataStore: DataStore) {
        self.init(context: dataStore.persistentContainer.viewContext)
    }

    static func ascendingdateSortDescriptor() -> [NSSortDescriptor] {
        [NSSortDescriptor(key: "id", ascending: true)]
    }
}
