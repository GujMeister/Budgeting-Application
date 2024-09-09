//
//  Date.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 03.09.24.
//

import Foundation

extension Date {
    func formattedWithoutYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: UserDefaults.standard.string(forKey: "LocalizeDefaultLanguage") ?? "en")
        dateFormatter.dateFormat = "d MMM"
        return dateFormatter.string(from: self)
    }
    
    func formattedWithYear() -> String {
        let dateFormatter = DateFormatter()
        let language = UserDefaults.standard.string(forKey: "LocalizeDefaultLanguage") ?? "en"
        
        // Set locale based on selected language
        dateFormatter.locale = Locale(identifier: language)
        
        // Use a different format depending on the language
        if language == "ka" {
            dateFormatter.dateFormat = "d MMM yyyy" // Georgian format
        } else {
            dateFormatter.dateFormat = "d MMM yyyy" // English format
        }
        
        return dateFormatter.string(from: self)
    }
    
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: UserDefaults.standard.string(forKey: "LocalizeDefaultLanguage") ?? "en")
        
        // Format the date with the month and day, without the suffix
        dateFormatter.dateFormat = "MMMM d"
        var formattedDate = dateFormatter.string(from: self)
        
        // Add the day suffix manually
        let daySuffix = self.daySuffix(for: self)
        formattedDate += daySuffix
        
        return formattedDate
    }
    
    func daySuffix(for date: Date) -> String {
        let day = Calendar.current.component(.day, from: date)
        let language = UserDefaults.standard.string(forKey: "LocalizeDefaultLanguage") ?? "en"
        
        if language == "ka" {
            return "recurring_day_suffix".translated() // Customize this as needed for Georgian
        }
        
        switch day {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "recurring_day_suffix".translated() // This would return "th" in English
        }
    }
}
