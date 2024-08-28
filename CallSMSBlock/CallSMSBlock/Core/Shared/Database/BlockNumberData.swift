import Foundation
import CoreData

class BlockNumberData: NSManagedObject, Identifiable {

    @NSManaged var id: String
    @NSManaged var name: String?
    @NSManaged var number: Int64
    @NSManaged var isBlocked: Bool
    @NSManaged var shouldUnlock: Bool
    @NSManaged var date: Date

    static func ascendingdateSortDescriptor() -> [NSSortDescriptor] {
        [NSSortDescriptor(key: "date", ascending: true)]
    }

    static func unblockedNumberPredicate() -> NSPredicate {
        NSPredicate(format: "isBlocked == false")
    }
}
