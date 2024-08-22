import SwiftUI
import CallKit

class AppDelegate: NSObject, UIApplicationDelegate {
    static let extensionIdentifier = "br.com.test.call.block.CallSMSBlock.CallDirectory"

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        reloadCallDirectory()
        return true
    }

    private func checkStatus() {
        CXCallDirectoryManager.sharedInstance
            .getEnabledStatusForExtension(withIdentifier: AppDelegate.extensionIdentifier,
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
                }
                print("getEnabledStatusForExtension", statusString)
            })
    }

    private func reloadCallDirectory() {
        CXCallDirectoryManager.sharedInstance.reloadExtension (
            withIdentifier: AppDelegate.extensionIdentifier,
            completionHandler: {(error) -> Void in
                print("reloadExtension")
                if let error = error {
                    print(error.localizedDescription)
                    // reloadExtension The operation couldn’t be completed. (com.apple.CallKit.error.calldirectorymanager error 6.)
                    //CXErrorCodeCallDirectoryManagerErrorExtensionDisabled = 6
                    // if get error 6, check Settings / Phone / Call blocking and identification / CallKitty switch on
                }
                self.checkStatus()
            })
    }
}
