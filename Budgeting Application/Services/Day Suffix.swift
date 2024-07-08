//
//  Day Suffix.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 08.07.24.
//

import Foundation

func daySuffix(for date: Date) -> String {
    let day = Calendar.current.component(.day, from: date)
    switch day {
    case 1, 21, 31: return "st"
    case 2, 22: return "nd"
    case 3, 23: return "rd"
    default: return "th"
    }
}
