//
//  DaySuffix.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 08.07.24.
//

import Foundation

func daySuffix(for date: Date) -> String {
    let day = Calendar.current.component(.day, from: date)
    let language = UserDefaults.standard.string(forKey: "LocalizeDefaultLanguage") ?? "en"

    if language == "ka" {
        return "\(day) რიცხვში"
    } else {
        switch day {
        case 1, 21, 31: return "\(day)st"
        case 2, 22: return "\(day)nd"
        case 3, 23: return "\(day)rd"
        default: return "\(day)th"
        }
    }
}
