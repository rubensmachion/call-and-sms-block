import SwiftUI

struct HomeViewCell: View {
    
    private let item: BlockNumberData

    init(item: BlockNumberData) {
        self.item = item
    }

    var body: some View {
        HStack {
            Image(systemName: "phone")
            VStack(alignment: .leading) {
                if let name = item.name {
                    Text(name)
                        .font(.headline)
                }
                Text(item.number.toFormattedPhoneNumber() ?? "-")
                    .font(.body)
                Text("Spam")
                    .font(.body)
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
}
