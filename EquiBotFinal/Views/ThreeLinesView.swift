//
//  ThreeLinesView.swift
//  EquiBotFinal
//
//  Created by Jennifer Lucero on 4/5/25.
//

import Foundation
import SwiftUI

struct ThreeLinesView: View{
    var body: some View{
        VStack(spacing: 3){
            Divider()
                .frame(width:25, height:2)
                .background(Color.black)
            Divider()
                .frame(width:25, height:2)
                .background(Color.black)
            Divider()
                .frame(width:25, height:2)
                .background(Color.black)
            Divider()
                .frame(width:25, height:2)
                .background(Color.black)
            
        }
        .padding()
    }
}
#Preview {
    ThreeLinesView()
}

