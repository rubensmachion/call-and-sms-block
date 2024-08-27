import Foundation

final class BlockNumberDatabaseManager {
    enum ManagerError: Error {
        case invalidaData
    }

    private static let fileName = "blockedNumbers.json"

    static let shared = BlockNumberDatabaseManager()

    // MARK: - Properties

    private(set) var numbersList: [BlockNumberModel] = []

    // MARK: - Init

    private init() {
        do {
            if FileManager.fileExists(filename: BlockNumberDatabaseManager.fileName) {
                try reloadWallets()
            } else  {
                try FileManager.save(numbersList, to: BlockNumberDatabaseManager.fileName)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    deinit {
        saveOpenedWallets()
    }

    func saveWallet(_ wallet: BlockNumberModel) throws {
        if isValidWallet(wallet) {
            if let index = getWalletIndex(from: wallet) {
                numbersList[index] = wallet
            } else { // new wallet
                numbersList.append(wallet)
            }

            try FileManager.save(numbersList, to: BlockNumberDatabaseManager.fileName)
        } else {
            throw ManagerError.invalidaData
        }
    }

    func reloadWallets() throws {
        let list = try FileManager.load(BlockNumberDatabaseManager.fileName,
                                        as: [BlockNumberModel].self)

        self.numbersList = list
    }

    func loadWallet(id: String) throws -> BlockNumberModel? {
        return numbersList.first(where: { $0.id == id })
    }

    func deleteAll() {
        numbersList.removeAll()
        saveOpenedWallets()
    }

    // MARK: - Private

    func saveOpenedWallets() {
        do {
            try FileManager.save(numbersList, to: BlockNumberDatabaseManager.fileName)
        } catch {
            print(error.localizedDescription)
        }
    }

    private func getWalletIndex(from number: BlockNumberModel) -> Int? {
        if let index = numbersList.firstIndex(where: { $0.id == number.id && !$0.id.isEmpty }) {
            return index
        } else if let index = numbersList.firstIndex(where: { $0.number == number.number }) {
            return index
        } else {
            return nil
        }
    }

    private func isValidWallet(_ number: BlockNumberModel) -> Bool {
        if number.number <= .zero {
            return false
        } else if number.id.isEmpty {
            return false
        }
        return true
    }
}
