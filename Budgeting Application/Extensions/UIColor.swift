//
//  UIColor.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 04.07.24.
//

import UIKit

extension UIColor {
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

// MARK: - Custom Colors
extension UIColor {
    static let infoViewColor = UIColor(hex: "468585")
    static let NavigationRectangleColor = UIColor(hex: "#6a9d9d")
    
    static var backgroundColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ? UIColor.black : UIColor(hex: "#F0F0F0")
            }
        } else {
            return UIColor(hex: "#F0F0F0")
        }
    }
    
    static var cellBackgroundColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ? UIColor(hex: "#333333") : UIColor.white
            }
        } else {
            return UIColor.white
        }
    }
    
    static var primaryTextColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ? UIColor(hex: "#e5e5e5") /*ideal*/ : UIColor(hex: "#262626")
            }
        } else {
            return UIColor.white
        }
    }
    
    static var secondaryTextColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ? UIColor(hex: "#333333") : UIColor.white
            }
        } else {
            return UIColor.white
        }
    }
    
    static var tertiaryTextColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ? UIColor(hex: "#c0c0c0") : UIColor(hex: "#393939")
            }
        } else {
            return UIColor.white
        }
    }
    
    static var quaternaryTextColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ? UIColor(hex: "#7f7f7f") : UIColor(hex: "#999999")
            }
        } else {
            return UIColor.white
        }
    }
    
    static var budgetViewBezierColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ? UIColor(hex: "#474747") : UIColor(hex: "#e4e4e4")
            }
        } else {
            return UIColor.white
        }
    }
}
