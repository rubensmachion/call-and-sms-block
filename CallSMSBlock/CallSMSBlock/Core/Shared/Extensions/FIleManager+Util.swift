import Foundation

extension FileManager {
    private static let groupBundle = Bundle.main.groupIdentifier

    static var documentsDirectory: URL {
        if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: FileManager.groupBundle) {
            return url
        } else {
            print("Not possible to access \(FileManager.groupBundle)")
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
    }

    static func save<T: Codable>(_ object: T, to filename: String) throws {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        try data.write(to: fileURL)

        print(fileURL)
    }

    static func load<T: Codable>(_ filename: String, as type: T.Type) throws -> T {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }

    static func remove(filename: String) throws {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        try FileManager.default.removeItem(at: fileURL)
    }

    static func fileExists(filename: String) -> Bool {
        let path = documentsDirectory.appendingPathComponent(filename).path()
        return FileManager.default.fileExists(atPath: path)
    }
}
