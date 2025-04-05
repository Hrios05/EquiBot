//
//  SFHacks_Extension.swift
//  EquiBotFinal
//
//  Created by Jennifer Lucero on 4/4/25.
//

import Foundation
import UIKit

extension UIColor{
    static let universalBlue=UIColor().colorFromHex(hex: "#8A2BE2")
    
    func colorFromHex(hex:String)->UIColor{
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#"){
            hexString.remove(at: hexString.startIndex)
        }
        if hexString.count != 4 {
                return UIColor.black
        }
        var rgb:UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000)>>16)/255.0,
                            green: CGFloat((rgb & 0xFF0000)>>8)/255.0,
                            blue: CGFloat(rgb & 0xFF0000)/255.0,
                            alpha:1.0)
            
        
    }
}
