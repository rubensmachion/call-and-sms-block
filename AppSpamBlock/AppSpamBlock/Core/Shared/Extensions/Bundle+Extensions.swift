import Foundation

extension Bundle {
    
    var appIdentifier: String {
        "br.com.test.call.block.CallSMSBlock"
    }

    var groupIdentifier: String {
        "group." + appIdentifier
    }

    var callDirectoryIdentifier: String {
        appIdentifier + ".CallDirectory"
    }

    var identificationSpamDirectoryIdentifier: String {
        appIdentifier + ".IdenficationSpam"
    }

    var blockSpamDirectoryIdentifier: String {
        appIdentifier + ".BlockSpam"
    }

    var persistenceContainerName: String {
        "AppCoreData"
    }
}
