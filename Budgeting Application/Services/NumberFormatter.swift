//
//  NumberFormatter.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 04.07.24.
//

import Foundation

class NumberFormatterHelper {
    static let shared = NumberFormatterHelper()
    
    private init() {}
    
    func format(amount: Double) -> String {
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
        return "$" + formattedNumber
    }
}
