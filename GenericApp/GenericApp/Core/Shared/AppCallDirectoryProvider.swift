import Foundation
import CallKit

final class AppCallDirectoryProvider {
    
    static let shared = AppCallDirectoryProvider()

    private init() {
        reloadCallDirectory()
    }

    func reloadCallDirectory() {
        CXCallDirectoryManager.sharedInstance.reloadExtension (
            withIdentifier: Bundle.main.callDirectoryIdentifier,
            completionHandler: {(error) -> Void in
                print("reloadExtension")
                if let error = error {
                    print(error.localizedDescription)
                    // reloadExtension The operation couldn’t be completed. (com.apple.CallKit.error.calldirectorymanager error 6.)
                    //CXErrorCodeCallDirectoryManagerErrorExtensionDisabled = 6
                    // if get error 6, check Settings / Phone / Call blocking and identification
                }
                self.checkStatus()
            })
    }

    func checkStatus() {
        CXCallDirectoryManager.sharedInstance
            .getEnabledStatusForExtension(withIdentifier: Bundle.main.callDirectoryIdentifier,
                                          completionHandler: {(enabledStatus, error)  -> Void in
                if let error = error {
                    print("getEnabledStatusForExtension", error.localizedDescription)
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
                print("getEnabledStatusForExtension", statusString)

                // TODO: Handle flow when extension disabled
            })
    }
}
