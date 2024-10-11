import Foundation
import PhoneNumberKit

public extension String {
    func friendlyNumber() -> String {
        return format(type: .international)
    }

    func unfriendlyNumber() -> String {
        return format(type: .e164)
    }

    private func format(type: PhoneNumberFormat) -> String {
        let phoneNumberUtility = PhoneNumberUtility()

        guard let phone = try? phoneNumberUtility.parse(self) else {
            return self
        }

        let formatted = phoneNumberUtility.format(phone, toType: type)

        return formatted
    }
}
