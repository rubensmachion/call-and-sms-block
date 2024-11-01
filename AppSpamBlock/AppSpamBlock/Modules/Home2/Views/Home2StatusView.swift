import SwiftUI


struct Home2StatusView: View {

    enum SecurityStatus {
        case enable(detail: String?)
        case disable
        case refreshing
    }

    private let status: Home2StatusView.SecurityStatus

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
                VStack(alignment: .leading, spacing: 2.0) {
                    Text(status.title)
                        .font(.system(size: 18.0,
                                      weight: .semibold))
                        .foregroundStyle(Color.primary)
                    Text(status.subtitle)
                        .font(.system(size: 17.0,
                                      weight: .regular))
                        .foregroundStyle(Color.secondary)
                    switch status {
                    case .enable(let detail):
                        if let detail = detail {
                            Text("Updated: \(detail)")
                                .font(.system(size: 14.0))
                                .foregroundStyle(Color.secondary)
                        }
                    default:
                        Text("")
                    }

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

extension Home2StatusView.SecurityStatus {
    var title: String {
        switch self {
        case .enable:
            return "Enabled"
        case .disable:
            return "Disabled"
        case .refreshing:
            return "Refreshing"
        }
    }

    var subtitle: String {
        switch self {
        case .enable:
            return "You are protected!"
        case .disable:
            return "You are not protected. Touch here to fix"
        case .refreshing:
            return "Wait"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .enable:
            return Color.green.opacity(0.15)
        case .disable:
            return Color.red.opacity(0.15)
        case .refreshing:
            return Color.yellow.opacity(0.15)
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
        case .refreshing:
            ProgressView()
                .frame(width: 24.0, height: 24.0)
        }
    }
}

#Preview {
    Home2StatusView(status: .enable(detail: "hoje, 10:40"))
}

#Preview {
    Home2StatusView(status: .disable)
}

#Preview {
    Home2StatusView(status: .refreshing)
}
