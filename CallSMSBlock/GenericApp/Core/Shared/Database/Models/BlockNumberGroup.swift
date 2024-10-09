import Foundation
import CoreData

class BlockNumberGroup: NSManagedObject, ManagedDataProtocol, Identifiable {

    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var subtitle: String
    @NSManaged var createdDate: Date
    @NSManaged var numbers: NSSet?

    convenience init(dataStore: DataStore) {
        self.init(context: dataStore.persistentContainer.viewContext)
    }

    static func ascendingdateSortDescriptor() -> [NSSortDescriptor] {
        [NSSortDescriptor(key: "createdDate", ascending: true)]
    }
}

extension BlockNumberGroup {

    @objc(addNumbersObject:)
    @NSManaged public func addToNumbers(_ value: BlockNumberData)

    @objc(removeNumbersObject:)
    @NSManaged public func removeFromNumbers(_ value: BlockNumberData)

    @objc(addNumbers:)
    @NSManaged public func addToNumbers(_ values: NSSet)

    @objc(removeNumbers:)
    @NSManaged public func removeFromNumbers(_ values: NSSet)

}
