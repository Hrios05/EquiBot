//
//  ContentView.swift
//  EquiBotFinal
//
//  Created by Hector Rios on 4/4/25.
//

import SwiftUI

struct RegisterView: View {
    var body: some View {
        VStack {
            Image("Logo").resizable()
                .imageScale(.large).frame(width: 512, height: 512)
                .padding(.leading, 43)
                .foregroundStyle(.tint)
            Text("EquiBot").font(Font.custom("Poppins-SemiBold", size: 50)).fontWeight(.bold)
        }
    }
}

#Preview {
    RegisterView()
}

