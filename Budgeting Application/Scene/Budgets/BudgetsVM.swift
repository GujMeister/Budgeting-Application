//
//  BudgetsVM.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 03.07.24.
//

import Foundation
import CoreData

enum TimePeriodBackwards: String, CaseIterable {
    case lastDay = "Last Day"
    case lastThreeDays = "Last 3 Days"
    case lastWeek = "Last Week"
    case lastMonth = "Last Month"
}

class BudgetsViewModel {
    var allBudgets: [BasicExpenseBudget] = [] {
        didSet {
            onBudgetsUpdated?()
        }
    }
    
    var favoritedBudgets: [BasicExpenseBudget] = [] {
        didSet {
            onFavoritedBudgetsUpdated?()
        }
    }
    
    var expenses: [BasicExpense] = [] {
        didSet {
            onExpensesUpdated?()
        }
    }
    
    var expensesByDate: [Date: [BasicExpense]] = [:]
    
    var sortedExpenseDates: [Date] {
        return expensesByDate.keys.sorted(by: >)
    }
    
    var selectedTimePeriod: TimePeriodBackwards = .lastWeek {
        didSet {
            filterExpenses()
        }
    }
    
    var onBudgetsUpdated: (() -> Void)?
    var onFavoritedBudgetsUpdated: (() -> Void)?
    var onExpensesUpdated: (() -> Void)?
    
    private var context: NSManagedObjectContext {
        return DataManager.shared.context
    }
    
    init() {
        loadBudgets()
        loadFavoritedBudgets()
        loadExpenses()
    }
    
    func loadBudgets() {
        let service = BasicExpenseService(context: context)
        allBudgets = service.fetchBasicExpenseBudgets()
    }
    
    func loadFavoritedBudgets() {
        if let savedBudgets = UserDefaults.standard.object(forKey: "favoritedBudgets") as? Data {
            let decoder = JSONDecoder()
            if let loadedBudgets = try? decoder.decode([BasicExpenseBudget].self, from: savedBudgets) {
                favoritedBudgets = loadedBudgets
            }
        }
    }
    
    func saveFavoritedBudgets() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(favoritedBudgets) {
            UserDefaults.standard.set(encoded, forKey: "favoritedBudgets")
            onFavoritedBudgetsUpdated?()
        }
    }
    
    func addBudgetToFavorites(_ budget: BasicExpenseBudget) {
        favoritedBudgets.append(budget)
        saveFavoritedBudgets()
    }
    
    func removeBudgetFromFavorites(_ budget: BasicExpenseBudget) {
        favoritedBudgets.removeAll { $0.category == budget.category }
        saveFavoritedBudgets()
    }
    
    func loadExpenses() {
        let service = BasicExpenseService(context: context)
        expenses = service.fetchBasicExpenses()
        filterExpenses()
    }
    
    func filterExpenses() {
        let calendar = Calendar.current
        let now = Date()
        var filtered: [BasicExpense] = []
        
        switch selectedTimePeriod {
        case .lastDay:
            let dayAgo = calendar.date(byAdding: .day, value: -1, to: now) ?? now
            filtered = expenses.filter { $0.date >= dayAgo }
        case .lastThreeDays:
            let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: now) ?? now
            filtered = expenses.filter { $0.date >= threeDaysAgo }
        case .lastWeek:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            filtered = expenses.filter { $0.date >= weekAgo }
        case .lastMonth:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            filtered = expenses.filter { $0.date >= monthAgo }
        }
        
        expensesByDate = Dictionary(grouping: filtered) { (expense) -> Date in
            let startOfDay = calendar.startOfDay(for: expense.date)
            return startOfDay
        }
        
        DispatchQueue.main.async {
            self.onExpensesUpdated?()
        }
    }
}
