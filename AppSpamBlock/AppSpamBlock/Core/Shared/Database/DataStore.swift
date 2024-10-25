import CoreData

final class DataStore {

    let persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private(set) lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()

    init() {
        let modelURL = Bundle(for: type(of: self)).url(forResource: Bundle.main.persistenceContainerName,
                                                       withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        persistentContainer = NSPersistentContainer(name: Bundle.main.persistenceContainerName,
                                                    managedObjectModel: managedObjectModel)
        let storeURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: Bundle.main.groupIdentifier)!
            .appendingPathComponent("\(Bundle.main.persistenceContainerName).sqlite")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        persistentContainer.persistentStoreDescriptions = [storeDescription]
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                // TODO: Handle error
                print("Failed to load CoreData: \(error.localizedDescription)")
            }
        }
    }

    func fetch<T>(sortDescriptors: [NSSortDescriptor]? = nil,
                  predicate: NSPredicate? = nil) async throws -> [T] where T: NSManagedObject {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        let result = try persistentContainer.viewContext.fetch(request)
        return result
    }

    func save(context: NSManagedObjectContext? = nil) throws {
        let newContext: NSManagedObjectContext? = context ?? persistentContainer.viewContext
        if newContext?.hasChanges ?? false {
            try newContext?.save()
        }
    }
}
