//
//  LoginView.swift
//  EquiBotFinal
//
//  Created by Jennifer Lucero on 4/4/25.
//

//
//  ContentView.swift
//  EquiBotFinal
//
//  Created by Hector Rios on 4/4/25.
//

import SwiftUI


struct InnerShadowModifier2: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    
                    .stroke(Color.white, lineWidth: 4)
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 2, y: 2)
                    
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: Color.white.opacity(0.7), radius: 3, x: -2, y: -2)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(width:256, height: 45)
                    
            )
    }
}


struct CustomTextFieldStyle2: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(red: 207/255.0, green: 223/255.0, blue: 223/255.0))
            .cornerRadius(20)
            .modifier(InnerShadowModifier2())
    }
}



struct LoginView: View {
    @State private var email: String=""
    @State private var password: String=""
    @State private var errorMessage = ""
    var body: some View {
        
        VStack(spacing:15) {
            Text("Sign in").font(                  Font.custom("Poppins-SemiBold", size: 50)).fontWeight(.bold).padding(.top, 150)
            Spacer()
            
            
            Group{
                
                TextField("Email", text: $email)
                    .textFieldStyle(CustomTextFieldStyle())
                    .font(.subheadline)
                    .foregroundColor(Color(red: 39/255.0, green: 39/255.0, blue: 39/255.0))
                
                SecureField("Password", text: $password)
                    .textFieldStyle(CustomTextFieldStyle())
                    .font(.subheadline)
                    .foregroundColor(Color(red: 39/255.0, green: 39/255.0, blue: 39/255.0))
                    
                
                if !errorMessage.isEmpty {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .font(.footnote)
                                    .padding(.bottom, 10)
                            }
                
            }
            .padding(.horizontal, 20)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.bottom, 10)
            }
            
            HStack{
                Text("Don't have an account?").font(Font.custom("Poppins", size: 15)).padding(.bottom,35)
                
                Text("Register!").font(Font.custom("Poppins-SemiBold", size: 15)).fontWeight(.bold).foregroundColor(.init(red: 0.1569, green:0.5765, blue: 0.6275)).padding(.bottom, 40)
                
            }
            Button(action: {

                AuthController.shared.login(email: email, password: password) { result in
                    switch result {
                    case .success:
                        // Handle success (e.g., navigate to another view)
                        break
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            }) {
                Text("Login")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color(red: 28/255.0, green: 42/255.0, blue: 77/255.0))
                    .cornerRadius(10)
                    .padding(.bottom, 30)
                    .padding(.top, -30)
            }
            
            VStack{
                Image("Logo").resizable()
                    .imageScale(.large).frame(width: 250, height: 250)
                    .padding(.leading, 18)
                    .foregroundStyle(.tint).padding(.top, 5)
            
                Text("EquiBot").font(Font.custom("Poppins-SemiBold", size: 40)).fontWeight(.bold).position(x: 200, y:-60)
                
            }
            
        }
        
    }
    
}


#Preview {
    LoginView()
}
