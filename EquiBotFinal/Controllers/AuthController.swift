import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthController {
    static let shared = AuthController()

    // MARK: - Create User

    func createUser(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: user.email, password: user.password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let authUser = authResult?.user else {
                completion(.failure(NSError(domain: "Auth", code: 0, message: "Could not get authenticated user")))
                return
            }

            let db = Firestore.firestore()
            db.collection("users").document(authUser.uid).setData([
                "firstName": user.firstName,
                "lastName": user.lastName,
                "email": user.email,
                "country": user.country,
                "state": user.state,
                "city": user.city
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }

    // MARK: - Login

    func login(email: String, password: String, completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let authUser = authResult?.user else {
                completion(.failure(NSError(domain: "Auth", code: 0, message: "Could not get authenticated user")))
                return
            }

            completion(.success(authUser))
        }
    }

    // MARK: - Save Name + Website

    func saveNameAndWebsite(userId: String, name: String, website: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).updateData([
            "name": name,
            "website": website
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Send Message

    func sendMessage(userId: String, messageContent: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let message = ChatMessage(content: messageContent, isUser: true)
        db.collection("users").document(userId).collection("messages").addDocument(data: [
            "content": message.content,
            "isUser": message.isUser
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

extension NSError {
    convenience init(domain: String, code: Int, message: String) {
        self.init(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
