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
        // Configure your views for the classification request
        if let call = classificationRequest as? ILCallClassificationRequest,
           let sender = call.callCommunications.last?.sender {
            phone = try? phoneNumberUtility.parse(sender)
            guard let phone = self.phone else {
                return
            }
            let formatted = phoneNumberUtility.format(phone, toType: .international)
            numberLabel?.text = "Sample Number: \(formatted)"

        } else if let message = classificationRequest as? ILMessageClassificationRequest,
                  let sender = message.messageCommunications.last?.sender {

            numberLabel?.text = "Sample Number: \(sender)"
        }
    }

    override func classificationResponse(for request:ILClassificationRequest) -> ILClassificationResponse {

        var payload: [String: AnyHashable] = [
            "description": "Spam Generic App"
        ]

        if let call = request as? ILCallClassificationRequest,
           let sender = call.callCommunications.last?.sender {
            payload["number"] = sender
            payload["type"] = "PHONE_CALL"

        } else if let message = request as? ILMessageClassificationRequest,
                  let sender = message.messageCommunications.last?.sender {
            payload["number"] = sender
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
