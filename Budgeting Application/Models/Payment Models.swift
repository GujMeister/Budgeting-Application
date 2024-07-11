//
//  Payment Models.swift
//  PersonalFinanceV2
//
//  Created by Luka Gujejiani on 30.06.24.
//

import Foundation
import UIKit

// MARK: - Basic Expense
struct BasicExpense: Codable {
    var category: BasicExpenseCategory
    var expenseDescription: String
    var amount: Double
    var date: Date
}

struct BasicExpenseBudget: Codable {
    var category: BasicExpenseCategory
    var totalAmount: Double
    var spentAmount: Double
    
    var remainingAmount: Double {
        totalAmount - spentAmount
    }
    
    var remainingPercentage: Double {
        spentAmount / totalAmount
    }
}

enum BasicExpenseCategory: String, CaseIterable, Codable {
    case food = "Food"
    case transportation = "Transportation"
    case groceries = "Groceries"
    case housing = "Housing"
    case utilities = "Utilities"
    case entertainment = "Entertainment"
    case education = "Education"
    case clothing = "Clothing"
    case personalCare = "Personal Care"
    case miscellaneous = "Miscellaneous"
    case others = "Others"
    
    var emoji: String {
        switch self {
        case .food:
            return "🍔"
        case .transportation:
            return "🚗"
        case .housing:
            return "🏠"
        case .utilities:
            return "💡"
        case .entertainment:
            return "🎬"
        case .education:
            return "📚"
        case .clothing:
            return "👗"
        case .personalCare:
            return "💄"
        case .miscellaneous:
            return "📦"
        case .others:
            return "❓"
        case .groceries:
            return "🛒"
        }
    }
}


// MARK: - Subscription
struct SubscriptionExpense: Identifiable {
    let id = UUID()
    var category: SubscriptionCategory
    var subscriptionDescription: String
    var amount: Double
    var startDate: Date
    var repeatCount: Int
}

enum SubscriptionCategory: String, CaseIterable {
    case streamingServices = "Streaming Services"
    case musicServices = "Music Services"
    case newsAndMagazines = "News and Magazines"
    case cloudStorage = "Cloud Storage"
    case softwareAndTools = "Software and Tools"
    case fitnessAndWellness = "Fitness and Wellness"
    case eCommerceAndMemberships = "E-Commerce and Memberships"
    case educationAndLearning = "Education and Learning"
    case gaming = "Gaming"
    case foodAndMealKits = "Food and Meal Kits"
    case healthAndBeauty = "Health and Beauty"
    case petServices = "Pet Services"
    case transportation = "Transportation"
    case utilities = "Utilities"
    case businessServices = "Business Services"
    
    var emoji: String {
        switch self {
        case .streamingServices:
            return "📺"
        case .musicServices:
            return "🎧"
        case .newsAndMagazines:
            return "📰"
        case .cloudStorage:
            return "☁️"
        case .softwareAndTools:
            return "🛠"
        case .fitnessAndWellness:
            return "💪"
        case .eCommerceAndMemberships:
            return "🛍"
        case .educationAndLearning:
            return "📚"
        case .gaming:
            return "🎮"
        case .foodAndMealKits:
            return "🍲"
        case .healthAndBeauty:
            return "💄"
        case .petServices:
            return "🐶"
        case .transportation:
            return "🚗"
        case .utilities:
            return "💡"
        case .businessServices:
            return "💼"
        }
    }
    
    var color: UIColor {
        switch self {
        case .streamingServices:
            return UIColor(hex: "#FFB6C1") // Light Pink
        case .musicServices:
            return UIColor(hex: "#87CEFA") // Light Sky Blue
        case .newsAndMagazines:
            return UIColor(hex: "#FFD700") // Gold
        case .cloudStorage:
            return UIColor(hex: "#B0E0E6") // Powder Blue
        case .softwareAndTools:
            return UIColor(hex: "#6A5ACD") // Slate Blue
        case .fitnessAndWellness:
            return UIColor(hex: "#48D1CC") // Medium Turquoise
        case .eCommerceAndMemberships:
            return UIColor(hex: "#40E0D0") // Turquoise
        case .educationAndLearning:
            return UIColor(hex: "#E6E6FA") // Lavender
        case .gaming:
            return UIColor(hex: "#8FBC8F") // Dark Sea Green
        case .foodAndMealKits:
            return UIColor(hex: "#B0C4DE") // Light Steel Blue
        case .healthAndBeauty:
            return UIColor(hex: "#4682B4") // Steel Blue
        case .petServices:
            return UIColor(hex: "#778899") // Light Slate Gray
        case .transportation:
            return UIColor(hex: "#FF6347") // Tomato
        case .utilities:
            return UIColor(hex: "#FFDEAD") // Navajo White
        case .businessServices:
            return UIColor(hex: "#FFEFD5") // Papaya Whip
        }
    }
    
    static func emoji(for category: String) -> String {
        return SubscriptionCategory(rawValue: category)?.emoji ?? "🔔"
    }
    
    static func color(for category: String) -> UIColor {
        return SubscriptionCategory(rawValue: category)?.color ?? .black
    }
}
// MARK: - Payments
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
    case internetBills = "Internet Bills"
    case healthInsurance = "Health Insurance"
    case lifeInsurance = "Life Insurance"
    case dentalInsurance = "Dental Insurance"
    case propertyTaxes = "Property Taxes"
    
    var emoji: String {
        switch self {
        case .insurance:
            return "🛡️"
        case .housePayments:
            return "🏠"
        case .carPayments:
            return "🚗"
        case .personalLoans:
            return "💸"
        case .studentLoans:
            return "🎓"
        case .creditCardPayments:
            return "💳"
        case .phoneBills:
            return "📱"
        case .internetBills:
            return "🌐"
        case .healthInsurance:
            return "🏥"
        case .lifeInsurance:
            return "❤️"
        case .dentalInsurance:
            return "🦷"
        case .propertyTaxes:
            return "🏡"
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
        case .internetBills:
            return UIColor(hex: "#40E0D0") // Turquoise
        case .healthInsurance:
            return UIColor(hex: "#8FBC8F") // Dark Sea Green
        case .lifeInsurance:
            return UIColor(hex: "#FFD700") // Gold
        case .dentalInsurance:
            return UIColor(hex: "#E6E6FA") // Lavender
        case .propertyTaxes:
            return UIColor(hex: "#B0E0E6") // Powder Blue
        }
    }
    
    static func emoji(for category: String) -> String {
        return PaymentsCategory(rawValue: category)?.emoji ?? "🔔"
    }
    
    static func color(for category: String) -> UIColor {
        return PaymentsCategory(rawValue: category)?.color ?? .black
    }
}



enum TimePeriodBackwards: String, CaseIterable {
    case today = "Today"
//    case lastDay = "Last Day"
    case lastThreeDays = "Last 3 Days"
    case lastWeek = "Last Week"
    case lastMonth = "Last Month"
}

enum TimePeriod: String, CaseIterable {
    case thisWeek = "This Week"
    case thisTwoWeeks = "This Two Weeks"
    case thisMonth = "This Month"
    case threeMonths = "3 Months"
    case sixMonths = "6 Months"
    case year = "Year"
}
