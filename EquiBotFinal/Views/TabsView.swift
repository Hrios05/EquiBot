import SwiftUI
import Firebase
import FirebaseFirestore

struct TabsView: View {
    let user: User?
    @State var messages: [ChatMessage]
    @Binding var savedWebsites: [String]

    var body: some View {
        TabView {
            ChatHistoryView(user: user, messages: $messages)
                .tabItem {
                    Label("Chat History", systemImage: "message.fill")
                        .font(.custom("Poppins-Regular", size: 14))
                }
                .tag(0)

            SavedWebsitesView(savedWebsites: $savedWebsites)
                .tabItem {
                    Label("Saved Websites", systemImage: "link")
                        .font(.custom("Poppins-Regular", size: 14))
                }
                .tag(1)
        }
        .accentColor(Color(red: 28/255.0, green: 42/255.0, blue: 77/255.0))
        .font(.custom("Poppins-Regular", size: 14))
    }
}

struct ChatHistoryView: View {
    let user: User?
    @Binding var messages: [ChatMessage]

    var body: some View {
        NavigationView {
            List {
                ForEach(messages.indices, id: \.self) { index in
                    if messages[index].isUser {
                        Section(header: Text(messages[index].content)
                            .font(.custom("Poppins-SemiBold", size: 16))
                            .foregroundColor(Color(red: 28/255.0, green: 42/255.0, blue: 77/255.0))) {
                            if index + 1 < messages.count && !messages[index + 1].isUser {
                                NavigationLink(destination: Text(messages[index + 1].content)
                                    .font(.custom("Poppins-Regular", size: 14))
                                    .padding()) {
                                    Text("View Bot Response")
                                        .font(.custom("Poppins-Regular", size: 14))
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Color(red: 28/255.0, green: 42/255.0, blue: 77/255.0))
                                        .cornerRadius(8)
                                }
                            } else {
                                Text("No bot response available.")
                                    .font(.custom("Poppins-Regular", size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Chat History")
            .font(.custom("Poppins-Regular", size: 14))
            .onAppear {
                loadChatHistory()
            }
        }
        .accentColor(Color(red: 28/255.0, green: 42/255.0, blue: 77/255.0))
    }

    func loadChatHistory() {
        guard let userId = user?.id else { return }
        let db = Firestore.firestore()

        db.collection("users").document(userId).collection("messages")
            .order(by: "timestamp")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error loading chat history: \(error.localizedDescription)")
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("No documents found in chat history")
                    return
                }

                messages = documents.compactMap { document in
                    let data = document.data()
                    guard let content = data["content"] as? String,
                          let isUser = data["isUser"] as? Bool else {
                        print("Error extracting data from document: \(document.documentID)")
                        return nil
                    }
                    return ChatMessage(content: content, isUser: isUser)
                }
            }
    }
}

struct SavedWebsitesView: View {
    @Binding var savedWebsites: [String]

    var body: some View {
        NavigationView {
            List {
                ForEach(savedWebsites, id: \.self) { website in
                    Link(destination: URL(string: website)!) {
                        HStack {
                            Image(systemName: "link.circle.fill")
                                .foregroundColor(Color(red: 28/255.0, green: 42/255.0, blue: 77/255.0))
                                .imageScale(.medium)
                            Text(website)
                                .font(.custom("Poppins-Regular", size: 14))
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .navigationTitle("Organizations/Websites")
            .font(.custom("Poppins-Regular", size: 14))
        }
    }
}

struct FavoritesView: View {
    var body: some View {
        Text("Favorites View Content")
            .font(.custom("Poppins-Regular", size: 14))
            .foregroundColor(.gray)
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings View Content")
            .font(.custom("Poppins-Regular", size: 14))
            .foregroundColor(.gray)
    }
}
#Preview {
    TabsView(user: nil, messages: [], savedWebsites: .constant([]))
}
