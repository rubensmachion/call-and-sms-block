import SwiftUI

struct HomeViewCell: View {
    
    private let item: HomeViewListModel

    init(item: HomeViewListModel) {
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
                Text(item.formattedNumber)
                    .font(.body)
                Text("Spam")
                    .font(.body)
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
}

#Preview {
    HomeViewCell(item: .init(id: UUID().uuidString,
                             number: 16991426807,
                             name: "Teste 1",
                             formattedNumber: "(16) 99142-6807"))
}
