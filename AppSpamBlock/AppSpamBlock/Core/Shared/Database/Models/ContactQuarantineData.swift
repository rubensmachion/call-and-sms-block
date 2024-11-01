import CoreData
import UtilKit

@objc protocol IContact {
    var id: Int64 { get set }
    var number: Int64 { get set }
    var date: Date { get set }
    var blocked: Bool { get set }
    var imported: Bool { get set }
    var descrip: String? { get set }
    var contactType: String? { get set }
    var formattedNumber: String? { get set }
}

enum ContactType: String {
    case blacklist
    case quarantine
}

@objc(ContactQuarantineData)
class ContactQuarantineData: NSManagedObject, ManagedDataProtocol, Identifiable, IContact {
    @NSManaged var id: Int64
    @NSManaged var number: Int64
    @NSManaged var date: Date
    @NSManaged var blocked: Bool
    @NSManaged var imported: Bool
    @NSManaged var descrip: String?
    @NSManaged var contactType: String?
    @NSManaged var formattedNumber: String?

    convenience init(dataStore: DataStore) {
        self.init(context: dataStore.context)
    }

    static func createEntity(context: NSManagedObjectContext) -> ContactQuarantineData {
        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: ContactQuarantineData.self),
                                                      in: context) else {
            fatalError("Failed to find entity description")
        }

        return ContactQuarantineData(entity: entity, insertInto: context)
    }

    static func ascendingdateSortDescriptor() -> [NSSortDescriptor] {
        [NSSortDescriptor(key: "id", ascending: true)]
    }

    static func ascendingNumberSort() -> [NSSortDescriptor] {
        [NSSortDescriptor(key: "number", ascending: true)]
    }

    static func ascendingBlackListPredicate() -> NSPredicate {
        NSPredicate(format: "contactType == %@", "blacklist")
    }

    static func blackListPredicate() -> NSPredicate {
        NSPredicate(format: "contactType == %@", "blacklist")
    }

    static func quarantineListPredicate() -> NSPredicate {
        NSPredicate(format: "contactType == %@", "quarantine")
    }

    static func blackUnimportedListPredicate() -> NSPredicate {
        NSPredicate(format: "blocked == %@", false)
    }

    static func quarantineUnimportedListPredicate() -> NSPredicate {
        NSPredicate(format: "imported == false")
    }

    override var description: String {
        return "id: \(id), descrip: \(descrip ?? "-"), number: \(number), date: \(date), blocked: \(blocked), imported: \(imported), contactType: \(contactType ?? "-")"
    }
}
