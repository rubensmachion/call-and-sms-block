import CoreData

protocol ManagedDataProtocol: NSManagedObject {
    static func ascendingdateSortDescriptor() -> [NSSortDescriptor]
    static func defaultPredicate() -> NSPredicate
    static func customPredicate(format: String, format predicateFormat: String, _ args: CVarArg...) -> NSPredicate
}

extension ManagedDataProtocol {
    static func defaultPredicate() -> NSPredicate {
        NSPredicate()
    }

    static func customPredicate(format: String, format predicateFormat: String, _ args: CVarArg...) -> NSPredicate {
        fatalError("Missing implementation")
    }
}
