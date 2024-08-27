import Foundation
import CoreData

class BlockNumberData: NSManagedObject {

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var number: Int64
    @NSManaged var isBlocked: Bool
    @NSManaged var shouldUnlock: Bool
    @NSManaged var date: Date

    convenience init(blockNumber: BlockNumberModel,
                     context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = blockNumber.id
        self.name = blockNumber.name
        self.number = Int64(blockNumber.number)
        self.isBlocked = blockNumber.isBlocked
        self.shouldUnlock = blockNumber.shouldUnlock
        self.date = .init()
    }

    static func ascendingdateSortDescriptor() -> [NSSortDescriptor] {
        [NSSortDescriptor(key: "date", ascending: true)]
    }

    static func unblockedNumberPredicate() -> NSPredicate {
        NSPredicate(format: "isBlocked == false")
    }
}
