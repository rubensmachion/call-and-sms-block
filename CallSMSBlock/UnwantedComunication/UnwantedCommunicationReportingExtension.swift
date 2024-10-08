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

    // Customize UI based on the classification request before the view is loaded
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


    // Provide a classification response for the classification request
    override func classificationResponse(for request:ILClassificationRequest) -> ILClassificationResponse {

        if let call = request as? ILCallClassificationRequest,
           let sender = call.callCommunications.last?.sender {
            let payload: [String: AnyHashable] = [
                "number": sender,
                "type": "PHONE_CALL",
                "identification": "Spam",
                "classification": 0
            ]

            let action: ILClassificationAction = .reportJunk  // or .none, .reportNotJunk, .reportJunkAndBlockSender
            let response = ILClassificationResponse(action: action)
            response.userInfo = payload

            return response

        } else if let message = request as? ILMessageClassificationRequest,
                  let sender = message.messageCommunications.last?.sender {
            let payload: [String: AnyHashable] = [
                "number": sender,
                "type": "TEXT",
                "identification": "Spam",
                "classification": 0
            ]

            let action: ILClassificationAction = .reportJunk  // or .none, .reportNotJunk, .reportJunkAndBlockSender
            let response = ILClassificationResponse(action: action)
            response.userInfo = payload

            return response
        } else {
            return ILClassificationResponse(action: .none)
        }
        //        return ILClassificationResponse(action: .none)
    }
}
