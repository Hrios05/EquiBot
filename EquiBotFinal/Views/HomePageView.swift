import SwiftUI
import Firebase
import FirebaseFirestore

struct HomePageView: View {
    let user: User?
    @State private var message = ""
    @State private var messages: [ChatMessage] = []
    @State private var errorMessage: String?
    @State private var contentHeight: CGFloat = 0
    @State private var scrollViewProxyValue: ScrollViewProxy? = nil
    @State private var savedWebsites: [String] = []

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    // Header
                    HStack {
                        NavigationLink(destination: TabsView(user: user, messages: messages, savedWebsites: $savedWebsites)) {
                            Image("align")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.leading, 30)

                        Spacer()

                        Image("Logo")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding(.leading, -48)

                        Spacer()

                        NavigationLink(destination: ProfilePageView(user: user)) {
                            Image("userProfile")
                                .resizable()
                                .frame(width: 35, height: 40)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.leading, -70)
                    }

                    // Messages
                    ScrollViewReader { scrollViewProxy in
                        ScrollView {
                            VStack(alignment: .leading) {
                                ForEach(messages) { msg in
                                    messageView(for: msg)
                                }
                            }
                            .background(
                                GeometryReader { geo in
                                    Color.clear.onAppear {
                                        contentHeight = geo.size.height
                                    }
                                }
                            )
                            .padding()
                        }
                        .frame(height: geometry.size.height * 0.75)
                        .onChange(of: messages) { _ , newMessages in
                            if let lastMessage = newMessages.last {
                                scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                        .onAppear {
                            scrollViewProxyValue = scrollViewProxy
                        }
                    }

                    // Text Input + Send Button
                    HStack {
                        TextField("Enter your message", text: $message)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

                        Button(action: sendMessage) {
                            Text("Send")
                                .font(.custom("Poppins-Regular", size: 16))
                                .padding()
                                .frame(width: 80, height: 40)
                                .background(Color(red: 28/255.0, green: 42/255.0, blue: 77/255.0))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                        .padding()
                    }

                    // Error Message
                    if let errorMessage = errorMessage {
                        Text("Error: \(errorMessage)")
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(.red)
                            .padding()
                    }
                }
            }
        }
        .onAppear {
            if messages.isEmpty {
                // Introduce EquiBot
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Delay to allow the UI to render
                    let initialMessage = "Hi, I'm EquiBot! Navigating CA Law, Made Easy!"
                    messages.append(ChatMessage(content: initialMessage, isUser: false))
                    saveMessageToFirebase(message: initialMessage, isUser: false)
                }
            }
        }
    }

    @ViewBuilder
    func messageView(for msg: ChatMessage) -> some View {
        if msg.isUser {
            HStack {
                Spacer()
                AnimatedTypingTextView(text: msg.content, onNameClick: saveNameAndWebsite, onAnimationComplete: scrollToBottom, onCharacterTyped: scrollToBottom)
                    .font(.custom("Poppins-Regular", size: 16))
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .padding(.vertical, 2)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .trailing)
            }
            .id(msg.id)
        } else {
            HStack {
                AnimatedFormattedText(text: msg.content, onNameClick: saveNameAndWebsite, onCharacterTyped: scrollToBottom)
                    .padding()
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.85, alignment: .leading)
                Spacer()
            }
            .id(msg.id)
        }
    }

    func sendMessage() {
        guard !message.isEmpty else { return }
        messages.append(ChatMessage(content: message, isUser: true))
        saveMessageToFirebase(message: message, isUser: true)

        getChatbotResponse(for: message, address: "Your Address Here") { response in
            DispatchQueue.main.async {
                messages.append(ChatMessage(content: response, isUser: false))
                saveMessageToFirebase(message: response, isUser: false)
            }
        }
        message = ""
    }

    // MARK: - Get Chatbot Response

    func getChatbotResponse(for userMessage: String, address: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/chatbot") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["message": userMessage, "address": address]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                completion("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received from server"
                }
                completion("No data received from server")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid response from server: \(httpResponse.statusCode)"
                }
                completion("Invalid response from server: \(httpResponse.statusCode)")
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let response = json["response"] as? String {
                DispatchQueue.main.async {
                    self.errorMessage = nil
                }
                let formattedResponse = formatLinks(response: response)
                completion(formattedResponse)
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid data format received from server"
                }
                completion("Invalid data format received from server")
            }
        }.resume()
    }


    func saveNameAndWebsite(name: String, website: String) {
        guard let userId = user?.id else { return }
        AuthController.shared.saveNameAndWebsite(userId: userId, name: name, website: website) { result in
            switch result {
            case .success:
                print("Name and website saved successfully")
            case .failure(let error):
                print("Failed to save name and website: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Firebase Integration

    func saveMessageToFirebase(message: String, isUser: Bool) {
        guard let userId = user?.id else { return }
        let db = Firestore.firestore()
        let chatMessage = ["content": message, "isUser": isUser, "timestamp": Timestamp(date: Date())] as [String : Any]

        db.collection("users").document(userId).collection("messages").addDocument(data: chatMessage) { error in
            if let error = error {
                print("Error saving message to Firebase: \(error.localizedDescription)")
            } else {
                print("Message saved to Firebase successfully")
            }
        }
    }

    // MARK: - Link Formatting

    func formatLinks(response: String) -> String {
        let linkRegex = try! NSRegularExpression(pattern: "\\[([^\\]]+)\\]|\\((https?://[^\\s]+)\\)", options: [])
        let matches = linkRegex.matches(in: response, options: [], range: NSRange(location: 0, length: response.utf16.count))

        var formattedResponse = response

        for match in matches.reversed() {
            if let nameRange = Range(match.range(at: 1), in: response) {
                // Extract the name if it's a name match
                let name = String(response[nameRange])
                formattedResponse = formattedResponse.replacingCharacters(in: nameRange, with: name)
            }
            if let urlRange = Range(match.range(at: 2), in: response), let url = URL(string: String(response[urlRange])) {
                // Extract the URL if it's a URL match
                let urlString = String(response[urlRange])
                formattedResponse = formattedResponse.replacingCharacters(in: urlRange, with: urlString)
                savedWebsites.append(urlString)
            }
        }

        return formattedResponse
    }

    func scrollToBottom() {
        guard let lastMessage = messages.last else { return }
        DispatchQueue.main.async {
            withAnimation {
                scrollViewProxyValue?.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}

struct AnimatedTypingTextView: View {
    let text: String
    let onNameClick: (String, String) -> Void
    let onAnimationComplete: () -> Void
    let onCharacterTyped: () -> Void
    @State private var displayedText = ""
    @State private var timer: Timer?

    var body: some View {
        Text(displayedText)
            .font(.custom("Poppins-Regular", size: 14))
            .opacity(displayedText.isEmpty ? 0 : 1)
            .animation(.none, value: displayedText)
            .onAppear {
                startTyping()
            }
            .onDisappear {
                timer?.invalidate()
            }
            .onTapGesture {
                onNameClick("ExampleName", "ExampleWebsite")
            }
    }

    private func startTyping() {
        displayedText = ""
        timer?.invalidate()
        var index = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if index < text.count {
                displayedText.append(text[text.index(text.startIndex, offsetBy: index)])
                index += 1
                onCharacterTyped()
            } else {
                timer?.invalidate()
                onAnimationComplete()
            }
        }
    }
}

struct AnimatedFormattedText: View {
    let text: String
    let onNameClick: (String, String) -> Void
    let onCharacterTyped: () -> Void
    @State private var displayedText = ""
    @State private var timer: Timer?

    var body: some View {
        FormattedText(text: displayedText, onNameClick: onNameClick)
            .onAppear {
                startTyping()
            }
            .onDisappear {
                timer?.invalidate()
            }
    }

    private func startTyping() {
        displayedText = ""
        timer?.invalidate()
        var index = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true) { _ in // Adjusted interval for faster typing
            if index < text.count {
                displayedText.append(text[text.index(text.startIndex, offsetBy: index)])
                index += 1
                onCharacterTyped()
            } else {
                timer?.invalidate()
            }
        }
    }
}

struct FormattedText: View {
    let text: String
    let onNameClick: (String, String) -> Void

    var body: some View {
        Text(addTapGestureToLinks(text: text, onNameClick: onNameClick))
    }

    private func addTapGestureToLinks(text: String, onNameClick: @escaping (String, String) -> Void) -> AttributedString {
        var attributedString = AttributedString(text)
        let linkRegex = try! NSRegularExpression(pattern: "\\[([^\\]]+)\\]|\\((https?://[^\\s]+)\\)", options: [])
        let matches = linkRegex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))

        for match in matches.reversed() {
            // Extract the name if it's a name match
            if let nameRange = Range(match.range(at: 1), in: text) {
                let name = String(text[nameRange])
                attributedString.replaceSubrange(Range<AttributedString.Index>(nameRange, in: attributedString)!, with: AttributedString(name))
            }
            // Extract the URL if it's a URL match
            if let urlRange = Range(match.range(at: 2), in: text), let url = URL(string: String(text[urlRange])) {
                let urlString = String(text[urlRange])
                var urlAttributedString = AttributedString(urlString)
                urlAttributedString.link = url
                attributedString.replaceSubrange(Range<AttributedString.Index>(urlRange, in: attributedString)!, with: urlAttributedString)
                if let range = urlAttributedString.range(of: urlString) {
                    attributedString[range].underlineStyle = .single
                    attributedString[range].foregroundColor = .blue
                }
            }
        }
        return attributedString
    }
}

extension AttributedString {
    mutating func bold(substring: String) {
        if let range = self.range(of: substring) {
            self[range].font = .boldSystemFont(ofSize: UIFont.systemFontSize)
        }
    }

    mutating func color(substring: String, to color: Color) {
        if let range = self.range(of: substring) {
            self[range].foregroundColor = color
        }
    }

    mutating func underline(substring: String) {
        if let range = self.range(of: substring) {
            self[range].underlineStyle = .single
        }
    }
}
#Preview {
    HomePageView(user: nil)
}
