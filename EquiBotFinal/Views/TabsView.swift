import SwiftUI

struct TabsView: View {
    let user: User?
    let messages: [ChatMessage]

    var body: some View {
        Text("Tabs View Content Here")
            .font(.largeTitle)
            .padding()
    }
}

#Preview {
    TabsView(user: nil, messages: [])
}
