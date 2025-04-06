//
//  ContentView.swift
//  EquiBotFinal
//
//  Created by Hector Rios on 4/4/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ZStack{
                Image("Logo").resizable()
                    .imageScale(.large).frame(width: 512, height: 512)
                    .padding(.leading, 41)
                    .foregroundStyle(.tint)
                    .padding(.bottom, 50)
                Text("EquiBot").font(Font.custom("Poppins-SemiBold", size: 50)).fontWeight(.bold).position(x:276,y:510)
                Text("Navigating CA Law, Made Easy.").font(Font.custom("Poppins-regular", size: 16)).fontWeight(.bold).position(x:280,y:700)
            }
        }
    }
}

#Preview {
    ContentView()
}
