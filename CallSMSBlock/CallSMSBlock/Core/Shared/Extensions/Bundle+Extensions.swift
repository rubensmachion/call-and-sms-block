import Foundation

extension Bundle {
    var appIdentifier: String {
        "br.com.test.call.block.CallSMSBlock"
    }

    var groupIdentifier: String {
        "group." + appIdentifier
    }

//    static let extensionIdentifier = "br.com.test.call.block.CallSMSBlock.CallDirectory"
    var callDirectoryIdentifier: String {
        appIdentifier + ".CallDirectory"
    }

    var persistenceContainerName: String {
        "AppCoreData"
    }
}
