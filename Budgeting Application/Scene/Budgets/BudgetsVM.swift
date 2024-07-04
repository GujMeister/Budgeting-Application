//
//  BudgetsVM.swift
//  Budgeting Application
//
//  Created by Luka Gujejiani on 03.07.24.
//

import Foundation
import CoreData

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
    
    // Method to refresh favorite budgets
    func refreshFavoriteBudgets() {
        let favoriteCategories = DataManager.shared.favoriteBudgets.map { $0.category }
        favoritedBudgets = allBudgets.filter { favoriteCategories.contains($0.category.rawValue) }
        onFavoritedBudgetsUpdated?()
    }

    func loadExpenses() {
        let service = BasicExpenseService(context: context)
        expenses = service.fetchBasicExpenses()
        filterExpenses()
        refreshFavoriteBudgets()
    }

    func addExpense(_ expense: BasicExpenseModel) {
        let service = BasicExpenseService(context: context)
        service.addExpense(expense)
        loadExpenses()
    }
    
    func loadBudgets() {
        let service = BasicExpenseService(context: context)
        allBudgets = service.fetchBasicExpenseBudgets()
    }
    
    func loadFavoritedBudgets() {
        DataManager.shared.fetchFavoriteBudgets()
        let favoriteCategories = DataManager.shared.favoriteBudgets.map { $0.category }
        favoritedBudgets = allBudgets.filter { favoriteCategories.contains($0.category.rawValue) }
        onFavoritedBudgetsUpdated?()
    }

    func addBudgetToFavorites(_ budget: BasicExpenseBudget) {
        DataManager.shared.addFavoriteBudget(category: budget.category.rawValue)
        loadFavoritedBudgets()
    }

    func removeBudgetFromFavorites(_ budget: BasicExpenseBudget) {
        DataManager.shared.removeFavoriteBudget(category: budget.category.rawValue)
        loadFavoritedBudgets()
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
