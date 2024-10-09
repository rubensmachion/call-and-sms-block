import SwiftUI

struct Home2CellView: View {

    private var item: Home2Item

    init(item: Home2Item) {
        self.item = item
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.white)
                .frame(minHeight: 100.0)
                .cornerRadius(12.0)
            VStack(alignment: .leading, spacing: 8.0) {
                Image(systemName: item.icon)
                Text(item.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                Text(item.subtitle)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}

#Preview {
    Home2CellView(item: .bitcoinWallet)
}
