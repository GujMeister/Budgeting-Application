//
//  BankPaymentExpense.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 13.07.24.
//

import UIKit

struct PaymentExpense: Identifiable {
    let id = UUID()
    var category: PaymentsCategory
    var paymentDescription: String
    var amount: Double
    var startDate: Date
    var repeatCount: Int
}

enum PaymentsCategory: String, CaseIterable {
    case insurance = "Insurance"
    case housePayments = "House Payments"
    case carPayments = "Car Payments"
    case personalLoans = "Personal Loans"
    case studentLoans = "Student Loans"
    case creditCardPayments = "Credit-Card Payments"
    case phoneBills = "Phone Bills"
    case rent = "Rent"
    case healthInsurance = "Health Insurance"
    case lifeInsurance = "Life Insurance"
    case propertyTaxes = "Property Taxes"
    case medicalBills = "Medical Bills"
    case other = "Other"
    case miscellaneous = "Miscellaneous"
    
    var emoji: String {
        switch self {
        case .insurance:
            return "🛡️"
        case .housePayments:
            return "🏠"
        case .carPayments:
            return "🚘"
        case .personalLoans:
            return "💸"
        case .studentLoans:
            return "🎓"
        case .creditCardPayments:
            return "💳"
        case .phoneBills:
            return "📱"
        case .rent:
            return "🏘️"
        case .healthInsurance:
            return "🏥"
        case .lifeInsurance:
            return "❤️"
        case .propertyTaxes:
            return "🏡"
        case .medicalBills:
            return "🩺"
        case .other:
            return "📒"
        case .miscellaneous:
            return "📝"
        }
    }
    
    var color: UIColor {
        switch self {
        case .insurance:
            return UIColor(hex: "#B0C4DE") // Light Steel Blue
        case .housePayments:
            return UIColor(hex: "#4682B4") // Steel Blue
        case .carPayments:
            return UIColor(hex: "#87CEFA") // Light Sky Blue
        case .personalLoans:
            return UIColor(hex: "#778899") // Light Slate Gray
        case .studentLoans:
            return UIColor(hex: "#6A5ACD") // Slate Blue
        case .creditCardPayments:
            return UIColor(hex: "#FFB6C1") // Light Pink
        case .phoneBills:
            return UIColor(hex: "#48D1CC") // Medium Turquoise
        case .rent:
            return UIColor(hex: "#40E0D0") // Turquoise
        case .healthInsurance:
            return UIColor(hex: "#8FBC8F") // Dark Sea Green
        case .lifeInsurance:
            return UIColor(hex: "#FFD700") // Gold
        case .propertyTaxes:
            return UIColor(hex: "#B0E0E6") // Powder Blue
        case .medicalBills:
            return UIColor(hex: "#D4AFDF") // Lavender Blush (pastel purple)
        case .other:
            return UIColor(hex: "#FFDFD3") // Floral White (pastel peach)
        case .miscellaneous:
            return UIColor(hex: "#C1E1C1") // Mint Cream (pastel green)
        }
    }
    
    static func emoji(for category: String) -> String {
        return PaymentsCategory(rawValue: category)?.emoji ?? "🔔"
    }
    
    static func color(for category: String) -> UIColor {
        return PaymentsCategory(rawValue: category)?.color ?? .black
    }
}
