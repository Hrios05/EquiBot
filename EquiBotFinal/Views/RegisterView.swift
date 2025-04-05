import SwiftUI

struct InnerShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white, lineWidth: 4)
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 2, y: 2)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: Color.white.opacity(0.7), radius: 3, x: -2, y: -2)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            )
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(red: 207/255.0, green: 223/255.0, blue: 223/255.0))
            .cornerRadius(15)
            .modifier(InnerShadowModifier())
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

    var body: some View {
        VStack(spacing: 8) {
            Text("Register")
                .font(Font.custom("Poppins-SemiBold", size: 45))
                .fontWeight(.bold)
                .padding(.bottom, 25)
                .foregroundColor(Color(red: 39/255.0, green: 39/255.0, blue: 39/255.0))

            Group {
                HStack {
                    TextField("First Name", text: $firstName)
                        .textFieldStyle(CustomTextFieldStyle())
                        .font(.subheadline)
                        .foregroundColor(Color(red: 39/255.0, green: 39/255.0, blue: 39/255.0))
                    
                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(CustomTextFieldStyle())
                        .font(.subheadline)
                        .foregroundColor(Color(red: 39/255.0, green: 39/255.0, blue: 39/255.0))
                }

                TextField("Email", text: $email)
                    .textFieldStyle(CustomTextFieldStyle())
                    .font(.subheadline)
                    .foregroundColor(Color(red: 39/255.0, green: 39/255.0, blue: 39/255.0))
                    .padding(.bottom, 25)

                TextField("Country", text: $country)
                    .textFieldStyle(CustomTextFieldStyle())
                    .font(.subheadline)
                    .foregroundColor(Color(red: 39/255.0, green: 39/255.0, blue: 39/255.0))

                TextField("State", text: $state)
                    .textFieldStyle(CustomTextFieldStyle())
                    .font(.subheadline)
                    .foregroundColor(Color(red: 39/255.0, green: 39/255.0, blue: 39/255.0))

                TextField("City", text: $city)
                    .textFieldStyle(CustomTextFieldStyle())
                    .font(.subheadline)
                    .foregroundColor(Color(red: 39/255.0, green: 39/255.0, blue: 39/255.0))
                    .padding(.bottom, 25)

                SecureField("Password", text: $password)
                    .textFieldStyle(CustomTextFieldStyle())
                    .font(.subheadline)
                    .foregroundColor(Color(red: 39/255.0, green: 39/255.0, blue: 39/255.0))

                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(CustomTextFieldStyle())
                    .font(.subheadline)
                    .foregroundColor(Color(red: 39/255.0, green: 39/255.0, blue: 39/255.0))
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

                let user = User(firstName: firstName, lastName: lastName, email: email, country: country, state: state, city: city, password: password)

                AuthController.shared.createUser(user: user) { result in
                    switch result {
                    case .success:
                        // Handle success (e.g., navigate to another view)
                        break
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
        }
        .padding()
    }
}

#Preview {
    RegisterView()
}
