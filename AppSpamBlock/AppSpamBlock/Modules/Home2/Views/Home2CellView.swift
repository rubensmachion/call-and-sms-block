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
                HStack {
                    Image(systemName: item.icon)
                    Spacer()
                    Text(item.status.0)
                        .padding(.leading, 8.0)
                        .padding(.trailing, 8.0)
                        .padding(.top, 4.0)
                        .padding(.bottom, 4.0)
                        .frame(alignment: .center)
                        .background(item.status.1)
                        .cornerRadius(8.0)
                        .foregroundColor(.white)
                }
                Text(item.title)
                    .font(.system(size: 18, 
                                  weight: .semibold))
                    .foregroundColor(.primary)
                Text(item.subtitle)
                    .font(.system(size: 17, 
                                  weight: .regular))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    Home2CellView(item: .block)
}
