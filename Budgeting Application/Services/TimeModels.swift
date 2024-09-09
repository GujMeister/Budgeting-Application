//
//  TimeModels.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 13.07.24.
//

import Foundation

enum TimePeriodBackwards: String, CaseIterable {
    case today = "time_period_backwards_today"
    case lastThreeDays = "time_period_backwards_last_three_days"
    case lastWeek = "time_period_backwards_last_week"
    case lastMonth = "time_period_backwards_last_month"

    func localized() -> String {
        return self.rawValue.translated()
    }
}

enum TimePeriod: String, CaseIterable {
    case thisWeek = "time_period_this_week"
    case thisTwoWeeks = "time_period_this_two_weeks"
    case thisMonth = "time_period_this_month"
    case threeMonths = "time_period_three_months"
    case sixMonths = "time_period_six_months"
    case year = "time_period_year"

    func localized() -> String {
        return self.rawValue.translated()
    }
}
