//
//  ProfilePageView.swift
//  EquiBotFinal
//
//  Created by Hector Rios on 4/5/25.
//


import SwiftUI


struct ProfilePageView: View {
    let user: User?
    @State private var message = ""
    @State private var messages: [ChatMessage] = []
    @State private var errorMessage: String?
    @State private var contentHeight: CGFloat = 0
    var body: some View {
        
        NavigationView {
            
            VStack {
                // Header
                HStack {
                    NavigationLink(destination: TabsView(user: user, messages: messages)) {
                        Image("align")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.leading, 30)
                    
                    Spacer()
                    
                    Image("Logo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .padding(.leading, -48)
                    
                    Spacer()
                    
                    NavigationLink(destination: ProfilePageView(user: user)) {
                        Image("userProfile")
                            .resizable()
                            .frame(width: 35, height: 40)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.leading, -70)
                }
                
            }
        }
    }
}
    


        #Preview {
            ProfilePageView(user: nil)
        }
