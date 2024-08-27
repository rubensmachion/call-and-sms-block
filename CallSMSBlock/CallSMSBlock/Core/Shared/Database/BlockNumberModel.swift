import Foundation

struct BlockNumberModel: Codable, Equatable {
    let id: String
    let name: String?
    let number: Int
    let isBlocked: Bool
    let shouldUnlock: Bool
}
