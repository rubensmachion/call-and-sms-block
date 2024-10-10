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

    case spam
    case bitcoinWallet
    case news
    case passwords
    case mfa
    case vpn

    var title: String {
        switch self {
        case .spam:
            return "SPAM"
        case .bitcoinWallet:
            return "BTC Wallet"
        case .news:
            return "News"
        case .passwords:
            return "Password"
        case .mfa:
            return "Authentication"
        case .vpn:
            return "VPN"
        }
    }

    var subtitle: String {
        switch self {
        case .spam:
            return "Keep your Call and SMS save"
        case .bitcoinWallet:
            return "Save and transfer"
        case .news:
            return "Keep up to date"
        case .passwords:
            return "Manager passwords"
        case .mfa:
            return "Create 2FA auth"
        case .vpn:
            return "Keep hide"
        }
    }

    var icon: String {
        switch self {
        case .spam:
            return "hand.raised.slash"
        case .bitcoinWallet:
            return "coloncurrencysign"
        case .news:
            return "newspaper"
        case .passwords:
            return "lock"
        case .mfa:
            return "key"
        case .vpn:
            return "network"
        }
    }

    var status: (String, Color) {
        switch self {
        case .spam:
            return (Home2ItemStatus.new.title, Home2ItemStatus.new.color)
        default:
            return (Home2ItemStatus.soon.title, Home2ItemStatus.soon.color)
        }
    }
}
