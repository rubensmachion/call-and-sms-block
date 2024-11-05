import CoreData

enum DataStoreError: Error {
    case invalidData
    case invalidContext
    case invalidEntity
}

protocol IDataStore {
    var context: NSManagedObjectContext { get }
    var backgroundContext: NSManagedObjectContext { get }

    func fetch<T>(sortDescriptors: [NSSortDescriptor]?,
                  predicate: NSPredicate?,
                  context: NSManagedObjectContext?,
                  fetchLimit: Int?,
                  offset: Int?) async throws -> [T] where T: NSManagedObject
    func fetchSingle<T>(context: NSManagedObjectContext?) async throws -> T where T: NSManagedObject
    func create<T>(context: NSManagedObjectContext) throws -> T where T: NSManagedObject
    func save(context: NSManagedObjectContext?) throws
}

extension IDataStore {

    func fetch<T>(sortDescriptors: [NSSortDescriptor]? = nil,
                  predicate: NSPredicate? = nil,
                  context: NSManagedObjectContext? = nil,
                  fetchLimit: Int? = nil,
                  offset: Int? = nil) async throws -> [T] where T: NSManagedObject {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        if let fetchLimit = fetchLimit {
            request.fetchLimit = fetchLimit
        }
        if let offset = offset {
            request.fetchOffset = offset
        }
        let result = try (context?.fetch(request) ?? self.context.fetch(request))
        return result
    }

    func fetchSingle<T>(context: NSManagedObjectContext? = nil) async throws -> T where T: NSManagedObject {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        let _context = context ?? self.context

        let results = try _context.fetch(request)
        guard let first = results.first else {
            return try self.create(context: _context)
        }
        return first
    }

    func create<T>(context: NSManagedObjectContext) throws -> T where T: NSManagedObject {
        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: T.self),
                                                      in: context) else {
            throw DataStoreError.invalidEntity
        }

        return T(entity: entity, insertInto: context)
    }

    func save(context: NSManagedObjectContext? = nil) throws {
        let newContext: NSManagedObjectContext? = context ?? self.context
        if newContext?.hasChanges ?? false {
            try newContext?.save()
        }
    }
}


final class DataStore: IDataStore {

    // MARK: - Properties

    private let persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private(set) lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()

    // MARK: - Init

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
                print("Failed to load CoreData: \(error.localizedDescription)")
            }
        }
    }

//    func printList(_ list: [NSManagedObject]) {
//#if DEBUG
//        print("----------------------------------------------")
//        list.forEach { obj in
//            print(obj.description)
//        }
//        print("----------------------------------------------")
//#endif
//    }
}
