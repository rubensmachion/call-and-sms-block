import SwiftUI

struct HomeViewCell: View {

    private let item: BlockNumberGroup

    init(item: BlockNumberGroup) {
        self.item = item
    }

    var body: some View {
        HStack {
            Image(systemName: "phone")
            VStack(alignment: .leading) {

                Text(item.title)
                    .font(.headline)
                Text(item.subtitle)
                    .font(.body)
                Text("Total: \(item.numbers?.count ?? 0)")
                    .font(.body)
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
}
