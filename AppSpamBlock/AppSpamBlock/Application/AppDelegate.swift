import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    private lazy var blackListRefresh: AppBackgroundTaskManager = {
        let bg = AppBackgroundTaskManager(task: .refreshBlackList)

        return bg
    }()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        _ = AppCallDirectoryProvider.shared
        
        _ = blackListRefresh

//        SecRequestSharedWebCredential(nil, nil) { credentials, error in
//            if let error = error {
//                print("\(#function): \(error.localizedDescription)")
//            } else if let credentials = credentials as? [[String: Any]], let firstCredential = credentials.first {
//                let username = firstCredential[kSecAttrAccount as String] as? String
//                let password = firstCredential[kSecSharedPassword as String] as? String
//                // Use the username and password
//                print("username: \(username)")
//                print("password: \(password)")
//            }
//        }

//        let domain: CFString = "api-dev.callspam.org" as CFString
//        let account = "rubens.machion" as CFString
//        let pass = "123456" as CFString
//
//        SecAddSharedWebCredential(domain, account, pass) { error in
//            if let error = error {
//                print("\(#function): \(error.localizedDescription)")
//            } else {
//                print("sucess")
//            }
//        }

        return true
    }


}
