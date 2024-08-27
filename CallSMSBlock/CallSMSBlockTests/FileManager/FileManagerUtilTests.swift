import Foundation
import XCTest

@testable import CallSMSBlock

final class FileManagerUtilTests: XCTestCase {

    private struct FileTest: Codable {
        let id: String
        let paramString: String
        let paramInt: Int
        let paramDecimal: Decimal
        let paramDouble: Double
    }

    private let fileName = "DataTest.json"
    private let listName = "ListDataTest.json"

    override func setUpWithError() throws { }

    override func tearDownWithError() throws {
        try? removeFile(fileName: fileName)
        try? removeFile(fileName: listName)
    }

    func testSaveFile() throws {
        saveMockFile()
    }

    func testSaveList() throws {
        saveMockList()
    }

    func testRemoveFiles() throws {
        saveMockFile()
        saveMockList()

        do {
            try removeFile(fileName: fileName)
            let loadedFile = try? loadFile(fileName: fileName) as? FileTest

            XCTAssertNil(loadedFile, "loadedFile shoud be nil")

            try removeFile(fileName: listName)
            let loadedList = try? loadList(fileName: listName) as? [FileTest]

            XCTAssertNil(loadedList, "loadedFile shoud be nil")

        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testFailRemoveFiles() throws {
        saveMockFile()
        saveMockList()

        do {
            try removeFile(fileName: "\(fileName)_missing")
            try removeFile(fileName: "\(listName)_missing")

            XCTFail("This test should return error")
        } catch { }
    }

    func testLoadFile() throws {
        saveMockFile()

        do {
            let loadedFile = try loadFile(fileName: fileName) as? FileTest

            XCTAssertNotNil(loadedFile, "loadedFile shoudn't be nil")

            if let loadedFile = loadedFile {
                XCTAssertFalse(loadedFile.id.isEmpty, "`ID` shouldn't empty")
                XCTAssertFalse(loadedFile.paramString.isEmpty, "`paramString` shouldn't empty")
                XCTAssertFalse(loadedFile.paramInt == .zero, "`paramInt` shouldn't zero")
                XCTAssertFalse(loadedFile.paramDouble == .zero, "`paramDouble` shouldn't zero")
                XCTAssertFalse(loadedFile.paramDecimal == .zero, "`paramDecimal` shouldn't zero")
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testLoadList() throws {
        saveMockList()

        do {
            let loadedList = try loadList(fileName: listName) as? [FileTest]

            XCTAssertNotNil(loadedList, "loadedList shoudn't be nil")
            XCTAssertFalse(loadedList?.isEmpty ?? true, "loadedList shoudn't be empty")

            if let loadedList = loadedList {
                loadedList.forEach { loadedFile in
                    XCTAssertFalse(loadedFile.id.isEmpty, "`ID` shouldn't empty")
                    XCTAssertFalse(loadedFile.paramString.isEmpty, "`paramString` shouldn't empty")
                    XCTAssertFalse(loadedFile.paramInt == .zero, "`paramInt` shouldn't zero")
                    XCTAssertFalse(loadedFile.paramDouble == .zero, "`paramDouble` shouldn't zero")
                    XCTAssertFalse(loadedFile.paramDecimal == .zero, "`paramDecimal` shouldn't zero")
                }
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testFileExists() throws {
        saveMockFile()
        saveMockList()

        let result1 = FileManager.fileExists(filename: fileName)
        XCTAssertTrue(result1, "File \(listName) should exists")

        let result2 = FileManager.fileExists(filename: listName)
        XCTAssertTrue(result2, "File \(listName) should exists")

        let unexistingfileTest = "unexistingfilename_test"
        let result3 = FileManager.fileExists(filename: unexistingfileTest)
        XCTAssertFalse(result3, "File \(unexistingfileTest) shouldn't exists")
    }

    // MARK: - Util and Helpers

    private func prepareFile() -> FileTest {
        FileTest(id: UUID().uuidString,
                 paramString: "Param String",
                 paramInt: Int.random(in: 1...100),
                 paramDecimal: .init(Double.random(in: 2.1...200.9)),
                 paramDouble: Double.random(in: 1.0...100.1))
    }

    private func saveMockFile() {
        let data = prepareFile()
        do {
            try FileManager.save(data, to: fileName)
        } catch {
            XCTFail("Save file error: \(error.localizedDescription)")
        }
    }

    private func saveMockList() {
        let list: [FileTest] = (0..<100).map { _ in self.prepareFile() }

        do {
            try FileManager.save(list, to: listName)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    private func removeFile(fileName: String) throws {
        try FileManager.remove(filename: fileName)
    }

    private func loadFile(fileName: String) throws -> Decodable? {
        try FileManager.load(fileName, as: FileTest.self)
    }

    private func loadList(fileName: String) throws -> [Decodable]? {
        try FileManager.load(fileName, as: [FileTest].self)
    }
}
