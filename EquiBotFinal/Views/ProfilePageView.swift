import SwiftUI

struct ProfilePageView: View {
    let user: User?
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var country = ""
    @State private var state = ""
    @State private var city = ""
    
    var body: some View {
        VStack {
            Spacer()
            // user profile image
            Image("userProfile")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(Circle()).padding(.top, 35).padding(.leading, -8)
            
            
            // Name and last name
            HStack {
                Text("Name: ") .font(.custom("Poppins-Regular", size: 16))
                    .bold()
                Text(user?.firstName ?? "N/A") .font(.custom("Poppins-Regular", size: 16))
                Text(user?.lastName ?? "N/A") .font(.custom("Poppins-Regular", size: 16))
            }
            .padding(.top, 0)
            
            // Email
            HStack {
                Text("Email: ") .font(.custom("Poppins-Regular", size: 16))
                    .bold()
                Text(user?.email ?? "N/A") .font(.custom("Poppins-Regular", size: 16))
            }
            .padding(.top, 5)
            
            // Addresses (Country, State, City)
            VStack(alignment: .center) {
                Text("Address:") .font(.custom("Poppins-Regular", size: 16))
                    .bold()
                    .padding(.bottom, 2)
                Text("Country: \(user?.country ?? "N/A")") .font(.custom("Poppins-Regular", size: 16))
                Text("State: \(user?.state ?? "N/A")") .font(.custom("Poppins-Regular", size: 16))
                Text("City: \(user?.city ?? "N/A")") .font(.custom("Poppins-Regular", size: 16))
            }
            .padding(.top, 5)
            .multilineTextAlignment(.center)
            
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .onAppear {
            // Populate state variables if user is available
            if let user = user {
                firstName = user.firstName
                lastName = user.lastName
                email = user.email
                country = user.country
                state = user.state
                city = user.city
            }
        }
    }
}

#Preview {
    ProfilePageView(user: User(id: UUID(), firstName: "John", lastName: "Doe", email: "john.doe@example.com", country: "USA", state: "CA", city: "Los Angeles", password: "password"))
}
