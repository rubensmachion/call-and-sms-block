import Foundation
import PhoneNumberKit

public extension Int {

    private var utility: PhoneNumberUtility {
        return PhoneNumberUtility()
    }

    func toFormattedPhoneNumber() -> String? {
        do {
            let phoneNumber = try utility.parse("\(self)")
            return utility.format(phoneNumber, toType: .national)
        } catch {
            print(error.localizedDescription)
        }

        return nil
    }
}

public extension Int64 {
    private var utility: PhoneNumberUtility {
        return PhoneNumberUtility()
    }

    func toFormattedPhoneNumber() -> String? {
        do {
            let phoneNumber = try utility.parse("\(self)")
            return utility.format(phoneNumber, toType: .national)
        } catch {
            print(error.localizedDescription + ": \(self)")
        }

        return nil
    }
}
