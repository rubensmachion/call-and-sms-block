import UIKit
import IdentityLookup
import IdentityLookupUI
import PhoneNumberKit

class UnwantedCommunicationReportingExtension: ILClassificationUIExtensionViewController {

    @IBOutlet weak var numberLabel: UILabel?

    private let phoneNumberUtility = PhoneNumberUtility()
    private var phone: PhoneNumber?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.extensionContext.isReadyForClassificationResponse = true
    }

    override func prepare(for classificationRequest: ILClassificationRequest) {
        if let call = classificationRequest as? ILCallClassificationRequest,
           let sender = call.callCommunications.last?.sender {
            numberLabel?.text = "Number: \(sender.friendlyNumber())"

        } else if let message = classificationRequest as? ILMessageClassificationRequest,
                  let sender = message.messageCommunications.last?.sender {

            numberLabel?.text = "Number: \(sender.friendlyNumber())"
        }
    }

    override func classificationResponse(for request:ILClassificationRequest) -> ILClassificationResponse {

        var payload: [String: AnyHashable] = [
            "description": "Suspected SPAM"
        ]

        if let call = request as? ILCallClassificationRequest,
           let sender = call.callCommunications.last?.sender {
            payload["number"] = sender.unfriendlyNumber()
            payload["type"] = "PHONE_CALL"

        } else if let message = request as? ILMessageClassificationRequest,
                  let sender = message.messageCommunications.last?.sender {
            payload["number"] = sender.unfriendlyNumber()
            payload["type"] = "TEXT"
        }
        if payload["number"] != nil {
            let action: ILClassificationAction = .reportJunk
            let response = ILClassificationResponse(action: action)
            response.userInfo = payload

            return response
        } else {
            return .init(action: .none)
        }
    }
}

private extension String {
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
