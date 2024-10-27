import CoreData

class BlackListData: NSManagedObject, ManagedDataProtocol, Identifiable {

    @NSManaged var id: Int64
    @NSManaged var number: Int64
    @NSManaged var date: Date
    @NSManaged var blocked: Bool

    convenience init(dataStore: DataStore) {
        self.init(context: dataStore.context)
    }

    static func ascendingdateSortDescriptor() -> [NSSortDescriptor] {
        [NSSortDescriptor(key: "id", ascending: true)]
    }

    override var description: String {
        return "id: \(id), number: \(number), date: \(date), blocked: \(blocked)"
    }
}
