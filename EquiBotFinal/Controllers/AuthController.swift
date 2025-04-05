//
//  AuthController.swift
//  EquiBotFinal
//
//  Created by Hector Rios on 4/5/25.
//

import Foundation
import FirebaseAuth

class AuthController {
    static let shared = AuthController()
    
    func createUser(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: user.email, password: user.password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            // Optionally, save additional user info to Firestore or Realtime Database
            completion(.success(()))
        }
    }
}
