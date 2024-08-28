import UIKit
import IdentityLookup
import IdentityLookupUI
import PhoneNumberKit

class UnwantedCommunicationReportingExtension: ILClassificationUIExtensionViewController {

    @IBOutlet weak var numberLabel: UILabel?

    private let phoneNumberUtility = PhoneNumberUtility()
    private var phone: PhoneNumber?
    private let dataStore = DataStore()

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
        } else if let message = classificationRequest as? ILMessageClassificationRequest {
            // TODO: Handle SMS message reporting
        }
    }
    
    // Provide a classification response for the classification request
    override func classificationResponse(for request:ILClassificationRequest) -> ILClassificationResponse {
        
        if request is ILCallClassificationRequest {
            // TODO: Call API to register this number

            return ILClassificationResponse(action: .reportJunk)
        } else {
            return ILClassificationResponse(action: .none)
        }
    }
}
