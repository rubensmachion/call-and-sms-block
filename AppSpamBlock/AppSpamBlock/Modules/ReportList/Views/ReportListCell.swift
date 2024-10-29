import SwiftUI

protocol IReportListCellItem {
    var title: String { get set }
    var subtitle: String { get set }
    var isImported: Bool { get set }
}

struct ReportListCell: View {

    private let item: any IReportListCellItem

    init(item: any IReportListCellItem) {
        self.item = item
    }

    var body: some View {
        let color = item.isImported ? Color.green : Color.gray
        HStack {
            Image(systemName: "phone")
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                if !item.subtitle.isEmpty {
                    Text(item.subtitle)
                        .font(.subheadline)
                }
            }
            Spacer()
            Circle()
                .foregroundColor(color)
                .frame(width: 12, height: 12)
            Image(systemName: "chevron.right")
        }
    }
}

#Preview {
    struct Item: IReportListCellItem {
        var title: String = "title"
        var subtitle: String = "subtitle"
        var isImported: Bool = false
    }
    return ReportListCell(item: Item())
}
