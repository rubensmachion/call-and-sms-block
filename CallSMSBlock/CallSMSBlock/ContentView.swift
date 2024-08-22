import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "phone")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Call & SMS Block")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
