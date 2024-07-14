//
//  SubscriptionExpense.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 13.07.24.
//

import UIKit

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
