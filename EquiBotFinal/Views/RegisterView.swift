import SwiftUI
import FirebaseAuth

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}

struct RegisterView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var country = ""
    @State private var state = ""
    @State private var city = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var user: User? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                Text("Register")
                    .font(Font.custom("Poppins-SemiBold", size: 45))
                    .fontWeight(.bold)
                    .padding(.bottom, 25)
                    .padding(.top, 40)
                    .foregroundColor(Color(red: 39/255.0, green: 39/255.0, blue: 39/255.0))

                Group {
                    HStack {
                        TextField("First Name", text: $firstName)
                            .textFieldStyle(CustomTextFieldStyle())
                            .font(.subheadline)
                            .foregroundColor(Color(.black))

                        TextField("Last Name", text: $lastName)
                            .textFieldStyle(CustomTextFieldStyle())
                            .font(.subheadline)
                            .foregroundColor(Color(.black))
                    }

                    TextField("Email", text: $email)
                        .textFieldStyle(CustomTextFieldStyle())
                        .font(.subheadline)
                        .foregroundColor(Color(.black))
                        .padding(.bottom, 25)

                    TextField("Country", text: $country)
                        .textFieldStyle(CustomTextFieldStyle())
                        .font(.subheadline)
                        .foregroundColor(Color(.black))

                    TextField("State", text: $state)
                        .textFieldStyle(CustomTextFieldStyle())
                        .font(.subheadline)
                        .foregroundColor(Color(.black))

                    TextField("City", text: $city)
                        .textFieldStyle(CustomTextFieldStyle())
                        .font(.subheadline)
                        .foregroundColor(Color(.black))
                        .padding(.bottom, 25)

                    SecureField("Password", text: $password)
                        .textFieldStyle(CustomTextFieldStyle())
                        .font(.subheadline)
                        .foregroundColor(Color(.black))

                    SecureField("Confirm Password", text: $confirmPassword)
                        .textFieldStyle(CustomTextFieldStyle())
                        .font(.subheadline)
                        .foregroundColor(Color(.black))
                }
                .padding(.horizontal, 20)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.bottom, 10)
                }

                Button(action: {
                    guard password == confirmPassword else {
                        errorMessage = "Passwords do not match"
                        return
                    }

                    let newUser = User(
                        id: UUID(),
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        country: country,
                        state: state,
                        city: city,
                        password: password
                    )
                    AuthController.shared.createUser(user: newUser) { result in
                        switch result {
                        case .success:
                            user = newUser
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                        }
                    }
                }) {
                    Text("Register")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color(red: 28/255.0, green: 42/255.0, blue: 77/255.0))
                        .cornerRadius(10)
                }
                .padding(.top, 20)

                Text("Already have an account?")
                    .font(Font.custom("Poppins-SemiBold", size: 15))
                    .padding(.top, 30)

                NavigationLink("Login", destination: LoginView())
                    .font(Font.custom("Poppins-SemiBold", size: 15))
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.1569, green: 0.5765, blue: 0.6275))
                    .padding(.bottom, 40)

                NavigationLink("", destination: HomePageView(user: user))
                    .hidden()
                    .onChange(of: user) { oldUser, newUser in
                        if newUser != nil {
                            // Trigger navigation to the HomePageView
                        }
                    }
            }
            .padding()
        }
    }
}

#Preview {
    RegisterView()
}
