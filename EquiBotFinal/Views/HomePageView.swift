import SwiftUI

struct HomePageView: View {
    @State private var message = ""
    @State private var messages: [Message] = []
    @State private var errorMessage: String?
    @State private var contentHeight: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // header
                HStack {
                    Text("EquiBot")
                        .font(.custom("Poppins-Regular", size: 45))
                        .fontWeight(.bold)
                        .padding()
                }
                Divider()
                    .frame(height: 2) // Thicker divider

                // messages
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(messages) { msg in
                                HStack {
                                    if msg.isUser {
                                        Spacer()
                                        TypingTextView(text: msg.content)
                                            .font(.custom("Poppins-Regular", size: 16)) // Slightly bigger font for user message
                                            .padding(8)
                                            .background(Color.gray.opacity(0.2))
                                            .foregroundColor(.black)
                                            .cornerRadius(10)
                                            .padding(.vertical, 2)
                                            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .trailing)
                                    } else {
                                        TypingTextView(text: msg.content)
                                            .font(.custom("Poppins-Regular", size: 14)) // Slightly smaller font for chatbot message
                                            .padding()
                                            .frame(maxWidth: UIScreen.main.bounds.width * 0.85, alignment: .leading) // 85% width
                                        Spacer()
                                    }
                                }
                                .id(msg.id)
                            }
                        }
                        .background(GeometryReader { geo -> Color in
                            DispatchQueue.main.async {
                                contentHeight = geo.size.height
                            }
                            return Color.clear
                        })
                        .padding()
                        .onChange(of: contentHeight) { _ in
                            if let lastMessage = messages.last {
                                scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                    .frame(height: geometry.size.height * 0.75) // Adjust height to ensure input section is visible
                }

                // text input and send button
                HStack {
                    TextField("Enter your message", text: $message)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button(action: sendMessage) {
                        Text("Send")
                            .font(.custom("Poppins-Regular", size: 16))
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    .padding()
                }

                // error message
                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
    }

    func sendMessage() {
        guard !message.isEmpty else { return }
        messages.append(Message(content: message, isUser: true))
        getChatbotResponse(for: message) { response in
            DispatchQueue.main.async {
                messages.append(Message(content: response, isUser: false))
            }
        }
        message = ""
    }

    func getChatbotResponse(for message: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/chatbot") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["message": message]
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
}

struct Message: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let isUser: Bool
}

struct TypingTextView: View {
    let text: String
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
    HomePageView()
}
