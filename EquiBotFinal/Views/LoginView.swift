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

struct LoginView: View {
    var body: some View {
        
        ZStack{
            Text("Sign in").font(                  Font.custom("Poppins-SemiBold", size: 50)).fontWeight(.bold)
                .position(x:200, y:175)
            
            Color(red: 0.1098, green: 0.1647, blue:  0.3020)
                .cornerRadius(20.0)
                .padding(.all)
                .frame(width: 280, height: 75)
                .position(x:200, y:400)
            
        
            
            
            
            VStack {
                
                /*TextField("Placeholder", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                 .textFieldStyle(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Text Field Style@*/DefaultTextFieldStyle()/*@END_MENU_TOKEN@*/).font(Font.custom("Poppins-SemiBold", size: 50))*/
                Text("Sign in")
                    .position(x:200, y:400)
                //Color(.white)
                
                    .foregroundColor(.white)
                
                
                
                
                /*Color(red: 207/255.0, green: 223/255.0, blue:  223/255.0)
                 
                 .cornerRadius(20.0)
                 .padding(.all)
                 .frame(width: 287, height: 75)
                 .position(x:200, y:-15)
                
                
                Color(red: 207/255.0, green: 223/255.0, blue:  223/255.0)
                
                    .cornerRadius(20.0)
                    .padding(.all)
                    .frame(width: 287, height: 75)
                    .position(x:200, y:-220)*/
                
                
                
                
            }
        }
            ZStack{
                Color(red: 207/255.0, green: 223/255.0, blue:  223/255.0)
                
                    .cornerRadius(20.0)
                    .padding(.all)
                    .frame(width: 287, height: 75)
                    .position(x:200, y:0)
                VStack{
                    Text("Username")
                        .position(x:130, y:0)
                    //Color(.white)
                        
                        .foregroundColor(.black)
                    
                }
            }
        ZStack{
            Color(red: 207/255.0, green: 223/255.0, blue:  223/255.0)
            
                .cornerRadius(20.0)
                .padding(.all)
                .frame(width: 287, height: 75)
                .position(x:200, y:-200)
            VStack{
                Text("Pasword")
                    .position(x:125, y:-200)
                //Color(.white)
                    
                    .foregroundColor(.black)
                
                Text("Don't have an account?").font(                  Font.custom("Poppins-SemiBold", size: 15))
                    .position(x:160, y:-100)
                Text("Register").font(                  Font.custom("Poppins-SemiBold", size: 15)).fontWeight(.bold)
                    .position(x:300, y:-200)
                
                
                Image("Logo").resizable()
                    .imageScale(.large).frame(width: 200, height: 200)
                    .padding(.leading, 40)
                    .foregroundStyle(.tint)
                    .position(x:185, y:-50)
                Text("EquiBot").font(Font.custom("Poppins-SemiBold", size: 50)).fontWeight(.bold)
                
            }
            VStack{
                
            }
        }
            
        }
    }


#Preview {
    LoginView()
}
