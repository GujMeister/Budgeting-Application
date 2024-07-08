//
//  NumberFormatter.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 04.07.24.
//

import UIKit

class NumberFormatterHelper {
    static let shared = NumberFormatterHelper()
    
    private init() {}
    
    func format(amount: Double, baseFont: UIFont, sizeDifference: Double) -> NSAttributedString {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if amount.truncatingRemainder(dividingBy: 1) == 0 {
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
        } else {
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
        }
        
        let formattedNumber = formatter.string(from: NSNumber(value: amount)) ?? "0"
        let fullString = "$" + formattedNumber
        
        let attributedString = NSMutableAttributedString(string: fullString)
        
        // Calculate smaller font sizes relative to the base font size
        let smallerFontSize = baseFont.pointSize * sizeDifference
        let smallerFont = baseFont.withSize(smallerFontSize)
        
        // Apply smaller font to the dollar sign
        attributedString.addAttribute(.font, value: smallerFont, range: NSRange(location: 0, length: 1))
        
        // Apply smaller font to the numbers after the decimal point
        if let range = fullString.range(of: ",") {
            let nsRange = NSRange(range, in: fullString)
            let decimalRange = NSRange(location: nsRange.location, length: fullString.count - nsRange.location)
            attributedString.addAttribute(.font, value: smallerFont, range: decimalRange)
        }
        
        return attributedString
    }
}

class PlainNumberFormatterHelper {
    static let shared = PlainNumberFormatterHelper()
    
    private init() {}
    
    func format(amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US") // Ensures the dollar sign is in the front
        formatter.currencySymbol = "$"
        
        // Custom logic to handle the fraction digits
        if floor(amount) == amount {
            formatter.minimumFractionDigits = 0
        } else {
            formatter.minimumFractionDigits = 2
        }
        formatter.maximumFractionDigits = 2
        
        let formattedNumber = formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
        return formattedNumber
    }
}
