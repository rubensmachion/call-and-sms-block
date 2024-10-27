import Foundation
import CallKit

typealias CallDirectoryStatus = CXCallDirectoryManager.EnabledStatus

final class AppCallDirectoryProvider {

    // MARK: - Properties

    static let shared = AppCallDirectoryProvider()

    private(set) var status: CallDirectoryStatus = .unknown

    // MARK: - Init

    private init() {
        reloadCallDirectory()
    }

    func reloadCallDirectory() {
        CXCallDirectoryManager.sharedInstance.reloadExtension (
            withIdentifier: Bundle.main.callDirectoryIdentifier,
            completionHandler: { (error) -> Void in
                print("Reloading CallDirectory")
                if let error = error {
                    print(error.localizedDescription)
                    // reloadExtension The operation couldn’t be completed. (com.apple.CallKit.error.calldirectorymanager error 6.)
                    //CXErrorCodeCallDirectoryManagerErrorExtensionDisabled = 6
                    // if get error 6, check Settings / Phone / Call blocking and identification
                }
                self.checkStatus()
            })
    }

    func checkStatus(completion: ((CallDirectoryStatus) -> Void)? = nil) {
        CXCallDirectoryManager.sharedInstance
            .getEnabledStatusForExtension(withIdentifier: Bundle.main.callDirectoryIdentifier,
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
