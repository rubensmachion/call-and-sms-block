import Foundation

struct PhoneNumberModel: Codable, Equatable, Identifiable, Hashable {
    var id: String?
    let name: String
    let number: String
}
