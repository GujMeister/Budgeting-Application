//
//  UIColor.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 04.07.24.
//

import UIKit

extension UIColor {
    static let customBlue = UIColor(hex: "1B1A55")
    static let customLightBlue = UIColor(hex: "#adb2d0")
    static let customBackground = UIColor(hex: "f4f3f9")
    
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension UIColor {
    static var myControlBackground: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                // Return one of two colors depending on light or dark mode
                return traits.userInterfaceStyle == .dark ?
                    UIColor(red: 0.5, green: 0.4, blue: 0.3, alpha: 1) :
                    UIColor(red: 0.3, green: 0.4, blue: 0.5, alpha: 1)
            }
        } else {
            // Same old color used for iOS 12 and earlier
            return UIColor(red: 0.3, green: 0.4, blue: 0.5, alpha: 1)
        }
    }
}
