import Foundation
import PhoneNumberKit

extension Int {

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

extension Int64 {

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
