import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var user: User? = nil
    @State private var isActive = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                Text("Login")
                    .font(Font.custom("Poppins-SemiBold", size: 45))
                    .fontWeight(.bold)
                    .padding(.bottom, 25)
                    .padding(.top, 40)
                    .foregroundColor(Color(red: 39/255.0, green: 39/255.0, blue: 39/255.0))

                TextField("Email", text: $email)
                    .textFieldStyle(CustomTextFieldStyle())
                    .font(.subheadline)
                    .foregroundColor(Color(.black))

                SecureField("Password", text: $password)
                    .textFieldStyle(CustomTextFieldStyle())
                    .font(.subheadline)
                    .foregroundColor(Color(.black))

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.bottom, 10)
                }

                Button(action: {
                    AuthController.shared.login(email: email, password: password) { result in
                        switch result {
                        case .success(let authUser):
                            // Fetch user data from Firestore and then initialize User
                            Firestore.firestore().collection("users").document(authUser.uid).getDocument { document, error in
                                if let document = document, document.exists, let data = document.data() {
                                    let user = User(
                                        id: UUID(uuidString: authUser.uid) ?? UUID(),
                                        firstName: data["firstName"] as? String ?? "",
                                        lastName: data["lastName"] as? String ?? "",
                                        email: data["email"] as? String ?? "",
                                        country: data["country"] as? String ?? "",
                                        state: data["state"] as? String ?? "",
                                        city: data["city"] as? String ?? "",
                                        password: password
                                    )
                                    self.user = user
                                    self.isActive = true
                                } else {
                                    errorMessage = error?.localizedDescription ?? "Failed to fetch user data"
                                }
                            }
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                        }
                    }
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color(red: 28/255.0, green: 42/255.0, blue: 77/255.0))
                        .cornerRadius(10)
                }
                .padding(.top, 20)

                Text("Don't have an account?")
                    .font(Font.custom("Poppins-SemiBold", size: 15))
                    .padding(.top, 30)

                NavigationLink("Register", destination: RegisterView())
                    .font(Font.custom("Poppins-SemiBold", size: 15))
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.1569, green: 0.5765, blue: 0.6275))
                    .padding(.bottom, 40)
            }
            .padding()
            .onAppear {
                if user != nil {
                    isActive = true
                }
            }
            .navigationDestination(isPresented: $isActive) {
                if let user = user {
                    HomePageView(user: user)
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
