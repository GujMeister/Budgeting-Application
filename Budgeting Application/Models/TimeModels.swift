//
//  TimeModels.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 13.07.24.
//

import Foundation

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
