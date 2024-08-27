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
            numberLabel?.text = "Number: \(formatted)"

        } else if let message = classificationRequest as? ILMessageClassificationRequest {

        } else {
            print("None")
        }
    }
    
    // Provide a classification response for the classification request
    override func classificationResponse(for request:ILClassificationRequest) -> ILClassificationResponse {
        
        if request is ILCallClassificationRequest {
            do {
                let data = BlockNumberData(context: dataStore.persistentContainer.viewContext)
                data.id = UUID().uuidString
                data.name = "Blocked via Report"
                data.date = .init()
                data.isBlocked = false
                data.shouldUnlock = false
                data.number = Int64(phone?.numberString ?? "0") ?? 0

            } catch {
                print(error.localizedDescription)
            }

            return ILClassificationResponse(action: .reportJunk)
        } else {
            return ILClassificationResponse(action: .none)
        }
    }
}
