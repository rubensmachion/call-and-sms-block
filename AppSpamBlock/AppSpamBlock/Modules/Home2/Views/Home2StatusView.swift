import SwiftUI

struct Home2StatusView: View {

    private let status: SecurityStatus

    // MARK: - Init

    init(status: SecurityStatus) {
        self.status = status
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(status.backgroundColor)
                .cornerRadius(12.0)
            HStack {
                VStack(alignment: .leading) {
                    Text(status.title)
                        .font(.system(size: 18.0,
                                      weight: .semibold))
                        .foregroundStyle(Color.primary)
                    Text(status.subtitle)
                        .font(.system(size: 17.0,
                                      weight: .regular))
                        .foregroundStyle(Color.secondary)
                    Spacer()
                }
                .padding()
                Spacer()
                VStack {
                    status.getIcon()
                }
                .padding(.trailing)
            }
        }
        .padding()
    }
}

extension SecurityStatus {
    var title: String {
        switch self {
        case .enable:
            return "Enabled"
        case .disable:
            return "Disabled"
        }
    }

    var subtitle: String {
        switch self {
        case .enable:
            return "You are protected!"
        case .disable:
            return "You are not protected. Touch here to fix"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .enable:
            return Color.green.opacity(0.15)
        case .disable:
            return Color.red.opacity(0.15)
        }
    }

    @ViewBuilder
    func getIcon() -> some View {
        switch self {
        case .enable:
            Image(systemName: "checkmark.seal.fill")
                .renderingMode(.template)
                .resizable()
                .frame(width: 24.0, height: 24.0)
                .foregroundStyle(Color.green)

        case .disable:
            Image(systemName: "xmark.circle.fill")
                .renderingMode(.template)
                .resizable()
                .frame(width: 24.0, height: 24.0)
                .foregroundStyle(Color.red)
        }
    }
}

#Preview {
    Home2StatusView(status: .enable)
}

#Preview {
    Home2StatusView(status: .disable)
}
