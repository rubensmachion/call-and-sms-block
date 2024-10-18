import Foundation
import SwiftUI

enum Home2ItemStatus {
    case new, soon, none

    var title: String {
        switch self {
        case .new:
            return "New"
        case .soon:
            return "Soon"
        case .none:
            return ""
        }
    }

    var color: Color {
        switch self {
        case .new:
            return Color(.systemBlue)
        case .soon:
            return Color(.systemYellow)
        case .none:
            return Color(.clear)
        }
    }
}

enum Home2Item: String, Identifiable, CaseIterable {
    var id: String { self.rawValue }

    case block
    case reportSpam
    case seach

    var title: String {
        switch self {
        case .block:
            return "Block"
        case .reportSpam:
            return "Report"
        case .seach:
            return "Search"
        }
    }

    var subtitle: String {
        switch self {
        case .block:
            return "Block phone number"
        case .reportSpam:
            return "Report a Spammer"
        case .seach:
            return "Check if a number is SPAM"
        }
    }

    var icon: String {
        switch self {
        case .block:
            return "hand.raised.slash"
        case .reportSpam:
            return "coloncurrencysign"
        case .seach:
            return "magnifyingglass"
        }
    }

    var status: (String, Color) {
        switch self {
        case .block:
            return (Home2ItemStatus.new.title, Home2ItemStatus.new.color)
        default:
            return (Home2ItemStatus.soon.title, Home2ItemStatus.soon.color)
        }
    }
}
