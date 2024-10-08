import SwiftUI

struct EmptyStateView: View {
    private var title: String

    init(title: String) {
        self.title = title
    }

    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .foregroundColor(.black)
        }
    }
}

//#Preview {
//    EmptyStateView(title: "Empty State View title")
//}

