import Foundation
import FirebaseAuth

struct User: Identifiable, Equatable, Hashable {
    let id: String
    var firstName: String
    var lastName: String
    var email: String
    var country: String
    var state: String
    var city: String
    var password: String

    init(id: UUID = UUID(), firstName: String, lastName: String, email: String, country: String, state: String, city: String, password: String) {
        self.id = id.uuidString
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.country = country
        self.state = state
        self.city = city
        self.password = password
    }

    init(authData: FirebaseAuth.User) {
        self.id = authData.uid
        self.firstName = ""
        self.lastName = ""
        self.email = authData.email ?? ""
        self.country = ""
        self.state = ""
        self.city = ""
        self.password = ""
    }

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
struct ChatMessage: Identifiable, Equatable {
    let id: String
    let content: String
    let isUser: Bool

    init(id: String = UUID().uuidString, content: String, isUser: Bool) {
        self.id = id
        self.content = content
        self.isUser = isUser
    }
}
