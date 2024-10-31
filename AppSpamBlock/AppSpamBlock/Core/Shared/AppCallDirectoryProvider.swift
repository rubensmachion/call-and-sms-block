import Foundation
import CallKit

typealias CallDirectoryStatus = CXCallDirectoryManager.EnabledStatus

final class AppCallDirectoryProvider {

    // MARK: - Properties

    static let shared = AppCallDirectoryProvider()

    private let directoryManager = CXCallDirectoryManager.sharedInstance

    private(set) var status: CallDirectoryStatus = .unknown

    // MARK: - Init

    private init() {
        //        reloadCallDirectory()
    }

    func reloadCallDirectory() {
        print(#function)
        directoryManager.reloadExtension (
            withIdentifier: Bundle.main.identificationSpamDirectoryIdentifier,
            completionHandler: { (error) -> Void in
                print("Reloading CallDirectory: \(Bundle.main.identificationSpamDirectoryIdentifier)")
                if let error = error as NSError? {
                    print("Erro ao carregar a extensão: \(error.localizedDescription), código: \(error.code)")
                    if error.code == 1 {
                        print("Erro genérico. Verifique as configurações e tente novamente.")
                    }
                } else {
                    print("Extensão recarregada com sucesso.")
                }
                self.checkStatus()
            })
    }

    func checkStatus(completion: ((CallDirectoryStatus) -> Void)? = nil) {
        directoryManager.getEnabledStatusForExtension(withIdentifier: Bundle.main.identificationSpamDirectoryIdentifier,
                                                      completionHandler: { [weak self] (enabledStatus, error) -> Void in
            if let error = error {
                print("getEnabledStatusForExtension", error.localizedDescription)
                completion?(.unknown)
                return
            }
            var statusString = ""
            switch enabledStatus {
            case .unknown:
                statusString = "unknown"
            case .disabled:
                statusString = "disabled"
            case .enabled:
                statusString = "enabled"
            default:
                statusString = "none"
            }
            print("CallDirectory:", statusString)

            self?.status = enabledStatus
            completion?(enabledStatus)
        })
    }
}
