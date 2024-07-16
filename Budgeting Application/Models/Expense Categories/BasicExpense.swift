//
//  BasicExpense.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 13.07.24.
//

import Foundation

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
