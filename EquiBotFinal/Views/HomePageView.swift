import SwiftUI

struct HomePageView: View {

    struct TypingTextView: View {
        let text: String
        let onNameClick: (String, String) -> Void

        var body: some View {
            Text(text)
                .onTapGesture {
                    onNameClick("ExampleName", "ExampleWebsite")
                }
        }
    }

    let user: User?
    @State private var message = ""
    @State private var messages: [ChatMessage] = []
    @State private var errorMessage: String?
    @State private var contentHeight: CGFloat = 0

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    // Header
                    HStack {
                        NavigationLink(destination: TabsView(user: user, messages: messages)) {
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
                            .onChange(of: messages) { _, newMessages in
                                if let lastMessage = newMessages.last {
                                    scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                        .frame(height: geometry.size.height * 0.75)
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
    }

    @ViewBuilder
    func messageView(for msg: ChatMessage) -> some View {
        if msg.isUser {
            HStack {
                Spacer()
                AnimatedTypingTextView(text: msg.content, onNameClick: saveNameAndWebsite)
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
                AnimatedTypingTextView(text: msg.content, onNameClick: saveNameAndWebsite)
                    .font(.custom("Poppins-SemiBold", size: 14))
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
        getChatbotResponse(for: message, address: "Your Address Here") { response in
            DispatchQueue.main.async {
                messages.append(ChatMessage(content: response, isUser: false))
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
                completion(response)
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid data format received from server"
                }
                completion("Invalid data format received from server")
            }
        }.resume()
    }

    // MARK: - Save Name + Website

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
}

struct AnimatedTypingTextView: View {
    let text: String
    let onNameClick: (String, String) -> Void
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
            } else {
                timer?.invalidate()
            }
        }
    }
}
#Preview {
    HomePageView(user: nil)
}
